create extension if not exists pgcrypto;
create table if not exists public.projects(
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 title text not null check(char_length(title) between 1 and 120), kind text not null default 'movie' check(kind in('movie','series','story')),
 description text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.scenes(
 id uuid primary key default gen_random_uuid(), project_id uuid not null references public.projects(id) on delete cascade,
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade, episode text not null default 'Episode 01',
 act text not null default 'Act I', title text not null default 'Scene 1', content text not null default '', notes text not null default '',
 revision integer not null default 1, updated_at timestamptz not null default now()
);
create table if not exists public.scene_versions(
 id uuid primary key default gen_random_uuid(), scene_id uuid not null references public.scenes(id) on delete cascade,
 project_id uuid not null references public.projects(id) on delete cascade, user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 episode text not null default '', act text not null default '', title text not null default '', content text not null default '',
 notes text not null default '', revision integer not null default 1, name text not null default 'Checkpoint', created_at timestamptz not null default now()
);
create index if not exists projects_owner_updated on public.projects(user_id,updated_at desc);
create index if not exists scenes_project_updated on public.scenes(project_id,updated_at desc);
create index if not exists versions_scene_created on public.scene_versions(scene_id,created_at desc);
alter table public.projects enable row level security;alter table public.scenes enable row level security;alter table public.scene_versions enable row level security;
create policy "owner projects" on public.projects for all to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy "owner scenes" on public.scenes for all to authenticated using(user_id=auth.uid() and exists(select 1 from public.projects p where p.id=project_id and p.user_id=auth.uid())) with check(user_id=auth.uid() and exists(select 1 from public.projects p where p.id=project_id and p.user_id=auth.uid()));
create policy "owner versions" on public.scene_versions for all to authenticated using(user_id=auth.uid() and exists(select 1 from public.projects p where p.id=project_id and p.user_id=auth.uid())) with check(user_id=auth.uid() and exists(select 1 from public.projects p where p.id=project_id and p.user_id=auth.uid()));
insert into storage.buckets(id,name,public) values('storynex-private','storynex-private',false) on conflict(id) do nothing;
create policy "private storynex files" on storage.objects for all to authenticated using(bucket_id='storynex-private' and (storage.foldername(name))[1]=auth.uid()::text) with check(bucket_id='storynex-private' and (storage.foldername(name))[1]=auth.uid()::text);
