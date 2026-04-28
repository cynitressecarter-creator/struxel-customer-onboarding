-- =============================================================================
-- Migration 0001: Core Schema
-- Struxel Dynamics — DeploymentWorkspace / Multi-Tenant Platform
-- =============================================================================

-- Extensions
create extension if not exists pgcrypto;

-- ── Enums ────────────────────────────────────────────────────────────────────

do $$ begin
  create type membership_role   as enum ('admin','member','viewer','support');
exception when duplicate_object then null; end $$;

do $$ begin
  create type membership_status as enum ('active','invited','disabled');
exception when duplicate_object then null; end $$;

do $$ begin
  create type delivery_method   as enum ('cloud','ecr','dockerhub','airgap','self_hosted');
exception when duplicate_object then null; end $$;

do $$ begin
  create type connection_type   as enum ('database','s3','api','webhook','other');
exception when duplicate_object then null; end $$;

do $$ begin
  create type task_status       as enum ('queued','running','succeeded','failed','canceled');
exception when duplicate_object then null; end $$;

do $$ begin
  create type hosting_model     as enum ('cloud_hosted','self_hosted','hybrid');
exception when duplicate_object then null; end $$;

do $$ begin
  create type contract_status   as enum ('draft','active','expired','canceled');
exception when duplicate_object then null; end $$;

do $$ begin
  create type audit_severity    as enum ('info','warning','error','critical');
exception when duplicate_object then null; end $$;

-- ── tenants ──────────────────────────────────────────────────────────────────

create table if not exists tenants (
  id                   uuid primary key default gen_random_uuid(),
  name                 text not null,
  slug                 text not null unique,
  company_name         text,
  hosting_model        hosting_model not null default 'cloud_hosted',
  cloud_tier           text,
  tenant_base_domain   text,
  bundle_id            text,
  enabled_products     text[] not null default '{}',
  license_key          text,
  license_issue_date   date,
  license_expiry_date  date,
  status               text not null default 'active',
  customer_email       text,
  customer_first_name  text,
  customer_last_name   text,
  se_owner             text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

create index if not exists tenants_slug_idx on tenants (slug);
create index if not exists tenants_status_idx on tenants (status);

-- ── tenant_settings ──────────────────────────────────────────────────────────

create table if not exists tenant_settings (
  id             uuid primary key default gen_random_uuid(),
  tenant_id      uuid not null references tenants(id) on delete cascade,
  logo_url       text,
  primary_color  text,
  company_name   text,
  support_email  text,
  custom_domain  text,
  metadata       jsonb not null default '{}',
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  unique(tenant_id)
);

create index if not exists tenant_settings_tenant_idx on tenant_settings (tenant_id);

-- ── tenant_memberships ───────────────────────────────────────────────────────

create table if not exists tenant_memberships (
  id          uuid primary key default gen_random_uuid(),
  tenant_id   uuid not null references tenants(id) on delete cascade,
  user_id     uuid references auth.users(id) on delete set null,
  email       text not null,
  role        membership_role not null default 'member',
  status      membership_status not null default 'invited',
  invited_by  text,
  invited_at  timestamptz,
  joined_at   timestamptz,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique(tenant_id, email)
);

create index if not exists tenant_memberships_tenant_idx on tenant_memberships (tenant_id);
create index if not exists tenant_memberships_user_idx   on tenant_memberships (user_id);
create index if not exists tenant_memberships_email_idx  on tenant_memberships (tenant_id, email);

-- ── tenant_plan_assignments ──────────────────────────────────────────────────

create table if not exists tenant_plan_assignments (
  id           uuid primary key default gen_random_uuid(),
  tenant_id    uuid not null references tenants(id) on delete cascade,
  bundle_id    text,
  product_ids  text[] not null default '{}',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique(tenant_id)
);

create index if not exists tenant_plan_tenant_idx on tenant_plan_assignments (tenant_id);

-- ── deployments ──────────────────────────────────────────────────────────────

create table if not exists deployments (
  id                uuid primary key default gen_random_uuid(),
  tenant_id         uuid not null references tenants(id) on delete cascade,
  name              text,
  delivery_method   delivery_method not null default 'cloud',
  agent_endpoint    text,
  agent_token       text,
  installed_version text,
  data_region       text,
  status            text not null default 'active',
  health_status     text not null default 'unknown',
  last_health_check timestamptz,
  config            jsonb not null default '{}',
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index if not exists deployments_tenant_idx on deployments (tenant_id);
create index if not exists deployments_status_idx on deployments (tenant_id, status);

-- ── tenant_data_connections ──────────────────────────────────────────────────

create table if not exists tenant_data_connections (
  id           uuid primary key default gen_random_uuid(),
  tenant_id    uuid not null references tenants(id) on delete cascade,
  name         text not null,
  type         connection_type not null default 'database',
  config       jsonb not null default '{}',
  status       text not null default 'active',
  created_by   text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists tenant_connections_tenant_idx on tenant_data_connections (tenant_id);

-- ── contracts ────────────────────────────────────────────────────────────────

create table if not exists contracts (
  id                          uuid primary key default gen_random_uuid(),
  tenant_id                   uuid not null references tenants(id) on delete cascade,
  bundle_id                   text,
  product_ids                 text[] not null default '{}',
  po_required                 boolean not null default false,
  po_approved                 boolean not null default false,
  billing_cycle               text not null default 'annual',
  currency                    text not null default 'USD',
  contract_value              numeric(12,2),
  start_date                  date,
  end_date                    date,
  status                      contract_status not null default 'draft',
  provisioning_blocked        boolean not null default false,
  provisioning_blocked_reason text,
  activated_at                timestamptz,
  activated_by                text,
  created_at                  timestamptz not null default now(),
  updated_at                  timestamptz not null default now()
);

create index if not exists contracts_tenant_idx on contracts (tenant_id);
create index if not exists contracts_status_idx on contracts (tenant_id, status);

-- ── tenant_tasks ─────────────────────────────────────────────────────────────

create table if not exists tenant_tasks (
  id           uuid primary key default gen_random_uuid(),
  tenant_id    uuid not null references tenants(id) on delete cascade,
  name         text not null,
  description  text,
  category     text,
  module       text,
  status       text not null default 'ready',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists tenant_tasks_tenant_idx on tenant_tasks (tenant_id);

-- ── tenant_task_runs ─────────────────────────────────────────────────────────

create table if not exists tenant_task_runs (
  id                  uuid primary key default gen_random_uuid(),
  tenant_id           uuid not null references tenants(id) on delete cascade,
  task_id             uuid references tenant_tasks(id) on delete set null,
  task_name           text,
  status              task_status not null default 'queued',
  result_summary      text,
  result_data         jsonb,
  triggered_by        text not null default 'manual',
  triggered_by_email  text,
  started_at          timestamptz,
  completed_at        timestamptz,
  created_at          timestamptz not null default now()
);

create index if not exists task_runs_tenant_created_idx on tenant_task_runs (tenant_id, created_at desc);
create index if not exists task_runs_tenant_status_idx  on tenant_task_runs (tenant_id, status);

-- ── tenant_audit_events ──────────────────────────────────────────────────────

create table if not exists tenant_audit_events (
  id             uuid primary key default gen_random_uuid(),
  tenant_id      uuid references tenants(id) on delete cascade,
  actor_type     text not null default 'user',
  actor_id       text,
  event_type     text not null,
  event_category text,
  details        jsonb not null default '{}',
  severity       audit_severity not null default 'info',
  created_at     timestamptz not null default now()
);

create index if not exists audit_events_tenant_created_idx on tenant_audit_events (tenant_id, created_at desc);
create index if not exists audit_events_type_idx           on tenant_audit_events (tenant_id, event_type);

-- ── tenant_billing_settings ──────────────────────────────────────────────────

create table if not exists tenant_billing_settings (
  id                   uuid primary key default gen_random_uuid(),
  tenant_id            uuid not null references tenants(id) on delete cascade,
  billing_email        text,
  stripe_customer_id   text,
  stripe_subscription_id text,
  subscription_status  text not null default 'none',
  plan_name            text,
  amount_cents         integer,
  billing_cycle        text,
  current_period_start timestamptz,
  current_period_end   timestamptz,
  synced_at            timestamptz,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  unique(tenant_id)
);

create index if not exists tenant_billing_tenant_idx on tenant_billing_settings (tenant_id);
