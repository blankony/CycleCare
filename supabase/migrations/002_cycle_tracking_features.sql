-- CycleCare Pass 1 schema extension. Apply after 001_initial_schema.sql.

alter table public.period_entries
  add column if not exists version integer not null default 1,
  add column if not exists prediction_confidence_at_entry text,
  add column if not exists prediction_model_version_at_entry text,
  add column if not exists prediction_sample_size_at_entry integer,
  add column if not exists prediction_snapshot_at timestamptz;

create table if not exists public.period_day_logs (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  period_entry_id uuid not null references public.period_entries(id) on delete cascade,
  log_date date not null,
  flow text not null check (flow in ('SPOTTING', 'LIGHT', 'MEDIUM', 'HEAVY')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version integer not null default 1
);

create table if not exists public.user_cycle_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  show_ovulation_estimate boolean not null default false,
  show_fertile_window boolean not null default false,
  reminder_enabled boolean not null default false,
  last_summary_period_id uuid references public.period_entries(id) on delete set null,
  last_successful_sync_at timestamptz,
  initial_sync_completed boolean not null default false,
  updated_at timestamptz not null default now(),
  version integer not null default 1
);

create unique index if not exists period_day_logs_active_unique_idx
  on public.period_day_logs(period_entry_id, log_date)
  where deleted_at is null;
create index if not exists period_day_logs_user_updated_idx
  on public.period_day_logs(user_id, updated_at);
create index if not exists period_day_logs_period_date_idx
  on public.period_day_logs(period_entry_id, log_date);
create index if not exists user_cycle_settings_updated_idx
  on public.user_cycle_settings(user_id, updated_at);

create or replace function public.validate_cyclecare_day_log()
returns trigger
language plpgsql
as $$
declare
  period public.period_entries%rowtype;
begin
  select * into period
  from public.period_entries
  where id = new.period_entry_id
    and user_id = new.user_id
    and deleted_at is null;
  if not found then
    raise exception 'period_entry_id tidak dimiliki oleh user';
  end if;
  if new.log_date < period.start_date
     or (period.end_date is not null and new.log_date > period.end_date)
     or new.log_date > current_date then
    raise exception 'log_date berada di luar rentang period';
  end if;
  return new;
end;
$$;

drop trigger if exists period_day_logs_valid_range on public.period_day_logs;
create trigger period_day_logs_valid_range
before insert or update on public.period_day_logs
for each row execute function public.validate_cyclecare_day_log();

create index if not exists period_entries_user_updated_idx
  on public.period_entries(user_id, updated_at);
create index if not exists period_entries_user_start_idx
  on public.period_entries(user_id, start_date);

create or replace function public.set_cyclecare_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  new.version = coalesce(old.version, 0) + 1;
  return new;
end;
$$;

drop trigger if exists period_entries_updated_at on public.period_entries;
create trigger period_entries_updated_at
before update on public.period_entries
for each row execute function public.set_cyclecare_updated_at();
drop trigger if exists period_day_logs_updated_at on public.period_day_logs;
create trigger period_day_logs_updated_at
before update on public.period_day_logs
for each row execute function public.set_cyclecare_updated_at();
drop trigger if exists user_cycle_settings_updated_at on public.user_cycle_settings;
create trigger user_cycle_settings_updated_at
before update on public.user_cycle_settings
for each row execute function public.set_cyclecare_updated_at();

alter table public.period_day_logs enable row level security;
alter table public.user_cycle_settings enable row level security;

drop policy if exists period_day_logs_owner on public.period_day_logs;
create policy period_day_logs_owner on public.period_day_logs
for all using (
  auth.uid() = user_id
  and exists (
    select 1 from public.period_entries period
    where period.id = period_entry_id and period.user_id = auth.uid()
  )
)
with check (
  auth.uid() = user_id
  and exists (
    select 1 from public.period_entries period
    where period.id = period_entry_id and period.user_id = auth.uid()
  )
);

drop policy if exists user_cycle_settings_owner on public.user_cycle_settings;
create policy user_cycle_settings_owner on public.user_cycle_settings
for all using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Keep all client writes scoped by auth.uid(); account deletion is handled by
-- the authenticated delete-account Edge Function, never by a service key.
