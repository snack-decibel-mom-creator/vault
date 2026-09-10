create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create type public.item_type as enum ('thought','content','tool','conversation');
create type public.content_source as enum ('youtube','instagram','x','url');
create type public.ai_provider as enum ('chatgpt','grok','gemini','other');

create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type public.item_type not null,
  title text not null,
  description text default '',
  body text default '',
  url text default '',
  source text default '',
  content_source public.content_source,
  provider public.ai_provider,
  rating int check (rating between 1 and 5),
  pinned boolean not null default false,
  favorite boolean not null default false,
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tags (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  unique(user_id, name)
);

create table if not exists public.item_tags (
  item_id uuid references public.items(id) on delete cascade,
  tag_id uuid references public.tags(id) on delete cascade,
  primary key(item_id, tag_id)
);

create table if not exists public.collections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  description text default '',
  color text default '#E5484D',
  created_at timestamptz not null default now()
);

create table if not exists public.collection_items (
  collection_id uuid references public.collections(id) on delete cascade,
  item_id uuid references public.items(id) on delete cascade,
  primary key(collection_id, item_id)
);

create index if not exists items_user_created_idx on public.items(user_id, created_at desc);
create index if not exists items_user_type_idx on public.items(user_id, type);
create index if not exists items_search_idx on public.items using gin (to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,'') || ' ' || coalesce(body,'')));

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id, display_name) values(new.id, coalesce(new.raw_user_meta_data->>'display_name','')) on conflict (id) do nothing;
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.items enable row level security;
alter table public.tags enable row level security;
alter table public.item_tags enable row level security;
alter table public.collections enable row level security;
alter table public.collection_items enable row level security;

create policy "profile owner" on public.profiles for all using (auth.uid() = id) with check (auth.uid() = id);
create policy "items owner" on public.items for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "tags owner" on public.tags for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "item tags owner" on public.item_tags for all using (exists(select 1 from public.items i where i.id=item_id and i.user_id=auth.uid())) with check (exists(select 1 from public.items i where i.id=item_id and i.user_id=auth.uid()));
create policy "collections owner" on public.collections for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "collection items owner" on public.collection_items for all using (exists(select 1 from public.collections c where c.id=collection_id and c.user_id=auth.uid())) with check (exists(select 1 from public.collections c where c.id=collection_id and c.user_id=auth.uid()));
