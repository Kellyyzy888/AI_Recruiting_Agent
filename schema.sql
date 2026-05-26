-- ═══════════════════════════════════════════════════════════════
-- Coach · Database Schema v2 — 三层记忆架构
-- Run this in Supabase Dashboard → SQL Editor → New Query → Run
-- ═══════════════════════════════════════════════════════════════

-- Single table per user: stores all app data as JSONB columns
CREATE TABLE IF NOT EXISTS user_data (
  user_id    UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- 第一层：用户 Profile（结构化，长期不变）
  profile    JSONB,

  -- 第二层：模块成果（结构化，每次单轮对话后更新）
  module_outcomes JSONB DEFAULT '{
    "resume": {
      "latest_version": null,
      "last_score": null,
      "key_suggestions": [],
      "updated_at": null
    },
    "mock_interview": {
      "total_sessions": 0,
      "latest_score": null,
      "trend": null,
      "weak_areas": [],
      "updated_at": null
    },
    "question_bank": {
      "completed_count": 0,
      "accuracy_by_category": {},
      "weak_topics": [],
      "updated_at": null
    }
  }',

  -- 第三层：对话记忆（滑动窗口 + 压缩摘要）
  conversations JSONB DEFAULT '{"onboarding":[],"resume":[],"interview":[]}',
  conversation_summaries JSONB DEFAULT '{"onboarding":"","resume":"","interview":""}',

  -- 其他状态
  progress   JSONB DEFAULT '{"profile":false,"resume":false,"interview":false}',
  rubric     JSONB DEFAULT '[]',
  resumes    JSONB DEFAULT '[]',
  settings   JSONB DEFAULT '{"language":"en"}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security: users can only access their own row
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON user_data FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own data"
  ON user_data FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own data"
  ON user_data FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own data"
  ON user_data FOR DELETE
  USING (auth.uid() = user_id);

-- Auto-create user_data row when a new user signs up
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_data (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists, then create
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
