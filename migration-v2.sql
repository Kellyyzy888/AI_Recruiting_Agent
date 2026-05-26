-- ═══════════════════════════════════════════════════════════════
-- Coach · Migration v2 — 添加三层记忆字段
-- 如果你已经跑过 v1 的 schema.sql，跑这个来升级
-- 如果是全新安装，直接跑 schema.sql 就行（已包含这些字段）
-- ═══════════════════════════════════════════════════════════════

-- 添加第二层：模块成果
ALTER TABLE user_data
ADD COLUMN IF NOT EXISTS module_outcomes JSONB DEFAULT '{
  "resume": {"latest_version": null, "last_score": null, "key_suggestions": [], "updated_at": null},
  "mock_interview": {"total_sessions": 0, "latest_score": null, "trend": null, "weak_areas": [], "updated_at": null},
  "question_bank": {"completed_count": 0, "accuracy_by_category": {}, "weak_topics": [], "updated_at": null}
}';

-- 添加第三层：对话压缩摘要
ALTER TABLE user_data
ADD COLUMN IF NOT EXISTS conversation_summaries JSONB DEFAULT '{"onboarding":"","resume":"","interview":""}';
