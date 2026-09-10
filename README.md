# Vault — Personal AI Knowledge Dashboard

A polished Flutter app concept for collecting thoughts, saved content, useful tools, AI conversations, and collections in one place.

## Stack
- Flutter + Material 3 with a custom near-black visual system
- Supabase Auth + Postgres + Row Level Security
- Riverpod for state
- GoRouter for protected navigation
- Geist / Geist Mono typography with a clean fallback

## Run
1. Install Flutter 3.24+.
2. From this directory run `flutter create .` to generate the native platform folders.
3. Run `flutter pub get`.
4. Create a Supabase project and apply `supabase/schema.sql` in the SQL editor.
5. Configure your Supabase URL and anon key.
6. Run `flutter run`.

## Demo mode
The app starts with local demo data until Supabase is configured. Demo content is clearly marked and can be replaced by real records through the capture and CRUD flows.

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
`supabase/schema.sql` contains the normalized schema, triggers, indexes, RLS policies, and a small demo seed function. The schema keeps user-owned data isolated by `auth.uid()`.

## GitHub
This repository is intended to be opened in Codex/Android Studio for Flutter emulator testing and iteration.
