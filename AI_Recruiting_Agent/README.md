# Coach · AI Recruiting, Remembered

A full-stack AI recruiting coach web app. Supabase for auth + data, Vercel for hosting + Claude API proxy.

## Architecture

```
Browser (index.html)
  │
  ├── Supabase Auth (signup/login)
  ├── Supabase Database (profiles, conversations, resumes, scores)
  │
  └── /api/claude ──→ Vercel Edge Function ──→ Anthropic API
                      (ANTHROPIC_API_KEY kept secret)
```

## Setup (15 minutes)

### 1. Supabase (you already have this)

**Run the database migration:**
1. Go to [Supabase Dashboard](https://supabase.com/dashboard) → your project
2. Click **SQL Editor** → **New Query**
3. Paste the contents of `schema.sql`
4. Click **Run**
5. You should see "Success. No rows returned" — that means it worked

**Disable email confirmation (for easier testing):**
1. Go to **Authentication** → **Providers** → **Email**
2. Toggle OFF "Confirm email"
3. Click **Save**

(You can re-enable this later when you want real email verification)

### 2. Anthropic API Key

1. Go to [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys)
2. Create a new API key
3. Copy it (starts with `sk-ant-api03-...`)
4. You'll paste this into Vercel in the next step

### 3. Deploy to Vercel

**Option A: Via GitHub (recommended)**
1. Create a new GitHub repo
2. Push this entire `coach-app/` folder to it
3. Go to [vercel.com](https://vercel.com) → New Project → Import your repo
4. In **Environment Variables**, add:
   - `ANTHROPIC_API_KEY` = your Anthropic API key from step 2
5. Click **Deploy**
6. Done! You'll get a URL like `https://your-project.vercel.app`

**Option B: Via Vercel CLI**
```bash
npm i -g vercel
cd coach-app
vercel
# Follow prompts, then:
vercel env add ANTHROPIC_API_KEY
# Paste your key
vercel --prod
```

### 4. Test it

1. Open your Vercel URL
2. Click "Get started" → Sign up with any email + password
3. Go through onboarding, upload a resume, try a mock interview
4. Log out → Log back in → Your data should be there
5. Open in a different browser / incognito → Same account, same data

## Project Structure

```
coach-app/
├── api/
│   └── claude.js           # Vercel Edge Function — proxies Claude API
├── public/
│   └── index.html          # The full app (React + Babel Standalone)
├── schema.sql              # Supabase database migration
├── package.json
├── vercel.json             # Routing config
└── README.md               # This file
```

## How data flows

| What | Where | How |
|------|-------|-----|
| User accounts | Supabase Auth | Email + password, JWT tokens |
| Profile, conversations, resumes, scores | Supabase Database (`user_data` table) | JSONB columns, Row Level Security |
| Claude AI responses | Anthropic API via `/api/claude` | Vercel Edge Function, API key on server |
| File parsing (PDF/DOCX) | Browser | pdf.js + mammoth.js, loaded from CDN |
| Resume exports (PDF/DOCX/Excel) | Browser | html2pdf + JSZip + SheetJS |

## Costs

| Service | Free tier | When you'd pay |
|---------|-----------|----------------|
| Supabase | 500MB DB, 50K users, unlimited auth | If you exceed free limits |
| Vercel | 100GB bandwidth, Edge Functions | If you exceed free limits |
| Anthropic API | None — pay per use | From the first API call (~$3/M input tokens for Sonnet) |

## Security notes

- Anthropic API key is **server-side only** (in Vercel env vars). Never exposed to browsers.
- Supabase Row Level Security ensures users can only access their own data.
- Passwords are hashed by Supabase Auth (bcrypt). Never stored in plaintext.
- The `/api/claude` endpoint requires a valid Supabase JWT — unauthenticated requests are rejected.

## Customization

**Change the AI model:** In `public/index.html`, search for `const MODEL = 'claude-sonnet-4-20250514'` and change it.

**Add a custom domain:** In Vercel dashboard → your project → Settings → Domains → Add your domain.

**Enable email confirmation:** Supabase dashboard → Authentication → Providers → Email → toggle ON "Confirm email". You may also want to customize the email template under Authentication → Email Templates.

**Change Supabase credentials:** The `SUPABASE_URL` and `SUPABASE_ANON_KEY` are in `public/index.html` near the top of the `<script>` block. The anon key is safe to expose (it's a publishable key, like Stripe's `pk_`). The service role key should NEVER be in frontend code.
# AI_Recruiting_Agent
# AI_Recruiting_Agent
# AI_Recruiting_Agent
# AI_Recruiting_Agent
# AI_Recruiting_Agent
# AI_Recruiting_Agent
# AI_Recruiting_Agent
# AI_Recruiting_Agent
