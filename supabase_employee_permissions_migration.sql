-- Run once in Supabase SQL Editor.
alter table public.profiles add column if not exists permissions jsonb not null default '[]'::jsonb;

alter table public.employee_work_sessions drop constraint if exists employee_work_sessions_status_check;
alter table public.employee_work_sessions add constraint employee_work_sessions_status_check
  check (status in ('working', 'lecture', 'break', 'lunch', 'meeting', 'technical_error', 'offline', 'training', 'personal', 'shadowing'));

drop policy if exists "Admins update employee permissions" on public.profiles;
create policy "Admins update employee permissions" on public.profiles for update to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
  with check (true);