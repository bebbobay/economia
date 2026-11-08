-- Incolla tutto in Supabase -> SQL Editor -> Run
create table if not exists public.app_state(
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data jsonb not null,
  version bigint not null default 1,
  updated_at timestamptz not null default now());
alter table public.app_state enable row level security;
create policy "own select" on public.app_state for select using (auth.uid()=user_id);
create policy "own insert" on public.app_state for insert with check (auth.uid()=user_id);
create policy "own update" on public.app_state for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
-- copia di sicurezza giornaliera: lo stato precedente alla prima modifica di ogni giorno
create table if not exists public.app_backup(user_id uuid not null, day date not null, data jsonb not null, primary key(user_id,day));
alter table public.app_backup enable row level security;
create policy "own backup select" on public.app_backup for select using (auth.uid()=user_id);
create or replace function public.snap() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into public.app_backup(user_id,day,data) values (old.user_id,current_date,old.data) on conflict do nothing; return new; end $$;
create trigger app_state_snap before update on public.app_state for each row execute function public.snap();
