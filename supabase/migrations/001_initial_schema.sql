-- CycleCare optional cloud schema. Apply in the Supabase SQL editor.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  timezone text not null default 'Asia/Jakarta',
  reminder_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.period_entries (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  start_date date not null,
  end_date date,
  cycle_length_days integer,
  period_duration_days integer,
  predicted_start_at_entry date,
  window_start_at_entry date,
  window_end_at_entry date,
  variance_days integer,
  classification text check (classification in ('EARLY','ON_WINDOW','LATE','INSUFFICIENT_DATA')),
  notes text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz
);

create table if not exists public.predictions (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  generated_at timestamptz not null,
  predicted_start date not null,
  window_start date not null,
  window_end date not null,
  baseline_cycle_days integer not null,
  variability_days integer not null,
  confidence text not null check (confidence in ('LOW','MEDIUM','HIGH')),
  based_on_cycles integer not null,
  model_version text not null
);

create index if not exists period_entries_user_updated_idx on public.period_entries(user_id, updated_at);
create index if not exists period_entries_user_start_idx on public.period_entries(user_id, start_date);
create index if not exists predictions_user_generated_idx on public.predictions(user_id, generated_at);

alter table public.profiles enable row level security;
alter table public.period_entries enable row level security;
alter table public.predictions enable row level security;

drop policy if exists profiles_owner on public.profiles;
create policy profiles_owner on public.profiles for all using (auth.uid() = id) with check (auth.uid() = id);
drop policy if exists period_entries_owner on public.period_entries;
create policy period_entries_owner on public.period_entries for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists predictions_owner on public.predictions;
create policy predictions_owner on public.predictions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- The client uses an authenticated user's UUID and must never use service_role.
