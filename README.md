# Vault — Personal AI Knowledge Dashboard

A polished Flutter app for collecting thoughts, saved content, useful tools, AI conversations, and collections in one place.

## Stack
- Flutter + Material 3 with a premium near-black visual system
- Supabase Auth + Postgres + Row Level Security
- Riverpod for state
- Supabase Edge Functions for private AI calls
- Geist / Geist Mono typography with a clean fallback

## Supabase
The production Supabase project is configured in `ap-south-1` and contains the Vault schema with profiles, items, tags, collections, relationships, indexes, triggers, and RLS policies.

The Flutter app uses Supabase when configured and keeps local demo data as a development fallback.

Run with:

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxx
```

Use only the publishable key in the Flutter client. Never put a Supabase secret/service-role key in the app.

## AI
Vault AI runs through the `vault-ai` Supabase Edge Function so the OpenAI API key never ships inside the Flutter app.

Recommended setup:
- `gpt-5.6-luna` for default capture summaries, tagging, extraction, and everyday Q&A
- `gpt-5.6-terra` for deeper synthesis, difficult reasoning, and high-value research
- `gpt-5.6-sol` only for premium/maximum-quality tasks where the extra cost is justified

Set `OPENAI_API_KEY` as a Supabase Edge Function secret before using AI. The function requires an authenticated Supabase session.

## Product structure
- Dashboard: overview, recent activity, quick capture
- Inbox: newly captured items
- Notes / Thoughts: lightweight markdown-like notes
- AI Conversations: ChatGPT, Grok, Gemini, other providers
- Saved Content: YouTube, Instagram, X, generic URLs
- Tools: useful tools with ratings and notes
- Collections: cross-type grouping
- Search: global search + filters
- Settings: profile and session controls

## Backend
`supabase/schema.sql` documents the database structure, while the live project is managed through Supabase migrations. RLS isolates user-owned data by `auth.uid()`.

## GitHub
This repository is intended to be opened in Codex/Android Studio for Flutter emulator testing and iteration.
