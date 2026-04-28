-- =============================================================================
-- Migration 0002: Row-Level Security (RLS)
-- Struxel Dynamics — DeploymentWorkspace / Multi-Tenant Platform
--
-- Security model: ADMIN-ONLY access via tenant_memberships.role = 'admin'
-- Policy helper: is_tenant_admin(p_tenant_id uuid) → boolean
-- =============================================================================

-- ── Helper functions ─────────────────────────────────────────────────────────

create or replace function is_tenant_admin(p_tenant_id uuid)
returns boolean
language sql
security definer
stable
as $$
  select exists (
    select 1
    from   tenant_memberships
    where  tenant_id = p_tenant_id
      and  user_id   = auth.uid()
      and  role      = 'admin'
      and  status    = 'active'
  );
$$;

create or replace function is_tenant_member(p_tenant_id uuid)
returns boolean
language sql
security definer
stable
as $$
  select exists (
    select 1
    from   tenant_memberships
    where  tenant_id = p_tenant_id
      and  user_id   = auth.uid()
      and  status    = 'active'
  );
$$;

-- ── Enable RLS on all tenant tables ─────────────────────────────────────────

alter table tenants                  enable row level security;
alter table tenant_settings          enable row level security;
alter table tenant_memberships       enable row level security;
alter table tenant_plan_assignments  enable row level security;
alter table deployments              enable row level security;
alter table tenant_data_connections  enable row level security;
alter table contracts                enable row level security;
alter table tenant_tasks             enable row level security;
alter table tenant_task_runs         enable row level security;
alter table tenant_audit_events      enable row level security;
alter table tenant_billing_settings  enable row level security;

-- ── tenants ──────────────────────────────────────────────────────────────────

drop policy if exists "tenant_admin_select" on tenants;
create policy "tenant_admin_select" on tenants
  for select using (is_tenant_admin(id));

drop policy if exists "tenant_admin_write" on tenants;
create policy "tenant_admin_write" on tenants
  for all using (is_tenant_admin(id));

-- ── tenant_settings ──────────────────────────────────────────────────────────

drop policy if exists "tenant_settings_admin_select" on tenant_settings;
create policy "tenant_settings_admin_select" on tenant_settings
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "tenant_settings_admin_write" on tenant_settings;
create policy "tenant_settings_admin_write" on tenant_settings
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_memberships ───────────────────────────────────────────────────────
-- Note: users can read their OWN membership row (needed for self-auth check)

drop policy if exists "membership_self_read" on tenant_memberships;
create policy "membership_self_read" on tenant_memberships
  for select using (user_id = auth.uid());

drop policy if exists "membership_admin_all" on tenant_memberships;
create policy "membership_admin_all" on tenant_memberships
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_plan_assignments ──────────────────────────────────────────────────

drop policy if exists "plan_admin_select" on tenant_plan_assignments;
create policy "plan_admin_select" on tenant_plan_assignments
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "plan_admin_write" on tenant_plan_assignments;
create policy "plan_admin_write" on tenant_plan_assignments
  for all using (is_tenant_admin(tenant_id));

-- ── deployments ──────────────────────────────────────────────────────────────

drop policy if exists "deployment_admin_select" on deployments;
create policy "deployment_admin_select" on deployments
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "deployment_admin_write" on deployments;
create policy "deployment_admin_write" on deployments
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_data_connections ──────────────────────────────────────────────────

drop policy if exists "connections_admin_select" on tenant_data_connections;
create policy "connections_admin_select" on tenant_data_connections
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "connections_admin_write" on tenant_data_connections;
create policy "connections_admin_write" on tenant_data_connections
  for all using (is_tenant_admin(tenant_id));

-- ── contracts ────────────────────────────────────────────────────────────────

drop policy if exists "contracts_admin_select" on contracts;
create policy "contracts_admin_select" on contracts
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "contracts_admin_write" on contracts;
create policy "contracts_admin_write" on contracts
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_tasks ─────────────────────────────────────────────────────────────

drop policy if exists "tasks_admin_select" on tenant_tasks;
create policy "tasks_admin_select" on tenant_tasks
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "tasks_admin_write" on tenant_tasks;
create policy "tasks_admin_write" on tenant_tasks
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_task_runs ─────────────────────────────────────────────────────────

drop policy if exists "task_runs_admin_select" on tenant_task_runs;
create policy "task_runs_admin_select" on tenant_task_runs
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "task_runs_admin_write" on tenant_task_runs;
create policy "task_runs_admin_write" on tenant_task_runs
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_audit_events ──────────────────────────────────────────────────────

drop policy if exists "audit_admin_select" on tenant_audit_events;
create policy "audit_admin_select" on tenant_audit_events
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "audit_admin_write" on tenant_audit_events;
create policy "audit_admin_write" on tenant_audit_events
  for all using (is_tenant_admin(tenant_id));

-- ── tenant_billing_settings ──────────────────────────────────────────────────

drop policy if exists "billing_admin_select" on tenant_billing_settings;
create policy "billing_admin_select" on tenant_billing_settings
  for select using (is_tenant_admin(tenant_id));

drop policy if exists "billing_admin_write" on tenant_billing_settings;
create policy "billing_admin_write" on tenant_billing_settings
  for all using (is_tenant_admin(tenant_id));
