-- Public opportunity information only. Never put athlete profiles, chat,
-- menstrual data, symptoms, or voice recordings in this catalogue.
create table if not exists public.opportunities (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  kind text not null check (kind in ('competition','trial','camp','government_scheme','ngo_support','private_sponsorship','scholarship','travel_support')),
  sport text,
  district text,
  eligibility text,
  benefit text,
  deadline date,
  source_name text not null,
  source_url text not null,
  verified_at timestamptz,
  status text not null default 'draft' check (status in ('draft','verified','expired')),
  created_at timestamptz not null default now()
);

alter table public.opportunities enable row level security;
revoke all on public.opportunities from anon, authenticated;
grant select on public.opportunities to anon, authenticated;
drop policy if exists "read verified current opportunities" on public.opportunities;
create policy "read verified current opportunities"
  on public.opportunities for select to anon, authenticated
  using (status = 'verified' and (deadline is null or deadline >= current_date));

create index if not exists opportunities_kind_deadline_idx
  on public.opportunities (kind, deadline) where status = 'verified';
