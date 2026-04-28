-- =============================================================================
-- Supabase Seed — First Tenant, Admin Membership, Plan Assignment,
--                 Sample Deployment, Task Run, and Data Connection
-- Struxel Dynamics — DeploymentWorkspace
-- =============================================================================
--
-- Usage:
--   supabase db reset --linked    (runs migrations + seed)
--   -- or paste into Supabase SQL Editor and click Run
--
-- IMPORTANT: Run migrations 0001_core.sql and 0002_rls.sql first.
--   The admin user (admin@example.com) must be created in Supabase Auth
--   before running this seed. After creating, copy their UUID and set
--   v_admin_auth_id below.
-- =============================================================================

DO $$
DECLARE
  v_tenant_id           UUID;
  v_contract_id         UUID;
  v_task_id             UUID;
  v_connection_id       UUID;
  -- IMPORTANT: Replace with the actual auth.users.id of your admin user.
  -- Create the user in Supabase Auth Dashboard first, then paste UUID here.
  v_admin_auth_id       UUID := '00000000-0000-0000-0000-000000000000';
BEGIN

  -- ===========================================================================
  -- 1) SEED TENANT
  -- ===========================================================================
  INSERT INTO tenants (
    name, slug, company_name, hosting_model, cloud_tier,
    tenant_base_domain, bundle_id, enabled_products,
    license_key, license_issue_date, license_expiry_date,
    status, customer_email, customer_first_name, customer_last_name,
    se_owner, created_at, updated_at
  ) VALUES (
    'Acme Corp',
    'acme-corp-seed',
    'Acme Corporation',
    'cloud_hosted',
    'shared',
    'tnt-acme.struxel.ai',
    'fintech-stack',
    ARRAY['bias-engine', 'audit-logger', 'risk-forecast', 'predictive-compliance'],
    'LK-SEED-2026-ACME',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    'active',
    'admin@example.com',
    'Alice',
    'Admin',
    'se@struxeldynamics.com',
    now(), now()
  )
  ON CONFLICT (slug) DO UPDATE SET updated_at = now()
  RETURNING id INTO v_tenant_id;

  RAISE NOTICE 'Seed tenant id: %', v_tenant_id;

  -- ===========================================================================
  -- 2) ACTIVE CONTRACT
  -- ===========================================================================
  INSERT INTO contracts (
    tenant_id, bundle_id, product_ids, po_required, po_approved,
    billing_cycle, currency, contract_value, start_date, end_date,
    status, provisioning_blocked, activated_at, activated_by,
    created_at, updated_at
  ) VALUES (
    v_tenant_id, 'fintech-stack',
    ARRAY['bias-engine', 'audit-logger', 'risk-forecast', 'predictive-compliance'],
    false, true, 'annual', 'USD', 60000.00,
    CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year',
    'active', false, now(), 'seed@struxeldynamics.com',
    now(), now()
  )
  RETURNING id INTO v_contract_id;

  RAISE NOTICE 'Seed contract id: %', v_contract_id;

  -- ===========================================================================
  -- 3) TENANT PLAN ASSIGNMENT
  -- ===========================================================================
  INSERT INTO tenant_plan_assignments (tenant_id, bundle_id, product_ids, created_at, updated_at)
  VALUES (v_tenant_id, 'fintech-stack', '{}', now(), now())
  ON CONFLICT (tenant_id) DO UPDATE SET bundle_id = EXCLUDED.bundle_id, updated_at = now();

  -- ===========================================================================
  -- 4) ADMIN TENANT MEMBERSHIP (linked to auth.users via user_id)
  -- ===========================================================================
  INSERT INTO tenant_memberships (
    tenant_id, user_id, email, role, status,
    invited_by, invited_at, joined_at, created_at, updated_at
  ) VALUES (
    v_tenant_id,
    v_admin_auth_id,          -- auth.users.id — replace placeholder above
    'admin@example.com',
    'admin', 'active',
    'seed@struxeldynamics.com', now(), now(), now(), now()
  )
  ON CONFLICT (tenant_id, email) DO UPDATE
    SET role = 'admin', status = 'active',
        user_id = EXCLUDED.user_id, updated_at = now();

  RAISE NOTICE 'Admin membership upserted for tenant %', v_tenant_id;

  -- ===========================================================================
  -- 5) DEPLOYMENT (cloud example)
  -- ===========================================================================
  INSERT INTO deployments (
    tenant_id, name, delivery_method, installed_version,
    data_region, status, health_status, created_at, updated_at
  ) VALUES (
    v_tenant_id, 'Acme Prod Workspace', 'cloud',
    '1.0.0', 'us-east-1', 'active', 'healthy', now(), now()
  );

  -- ===========================================================================
  -- 6) SAMPLE TENANT TASK
  -- ===========================================================================
  INSERT INTO tenant_tasks (
    tenant_id, name, description, category, module, status, created_at, updated_at
  ) VALUES (
    v_tenant_id,
    'Vendor Risk Assessment Scan',
    'Scans all registered vendors against the current risk ruleset.',
    'Governance', 'vendor-risk', 'ready', now(), now()
  )
  RETURNING id INTO v_task_id;

  -- ===========================================================================
  -- 7) SAMPLE TASK RUN (completed)
  -- ===========================================================================
  INSERT INTO tenant_task_runs (
    tenant_id, task_id, task_name, status, result_summary, result_data,
    triggered_by, triggered_by_email, started_at, completed_at, created_at
  ) VALUES (
    v_tenant_id, v_task_id,
    'Vendor Risk Assessment Scan', 'succeeded',
    'Scan completed. 12 vendors assessed; 2 flagged high risk.',
    jsonb_build_object('vendors_scanned',12,'high_risk',2,'medium_risk',4,'low_risk',6),
    'manual', 'admin@example.com',
    now() - INTERVAL '1 hour', now() - INTERVAL '59 minutes', now()
  );

  -- ===========================================================================
  -- 8) SAMPLE DATA CONNECTION
  -- ===========================================================================
  INSERT INTO tenant_data_connections (
    tenant_id, name, type, config, status, created_by, created_at, updated_at
  ) VALUES (
    v_tenant_id, 'Acme Production DB', 'database',
    jsonb_build_object(
      'host','db.acme-example.com','port',5432,
      'database','acme_production','username','readonly_user','ssl',true
    ),
    'active', 'admin@example.com', now(), now()
  )
  RETURNING id INTO v_connection_id;

  -- ===========================================================================
  -- 9) AUDIT EVENT (seed marker)
  -- ===========================================================================
  INSERT INTO tenant_audit_events (
    tenant_id, actor_type, actor_id, event_type, event_category, details, severity, created_at
  ) VALUES (
    v_tenant_id, 'system', 'seed.sql', 'tenant.seed_applied', 'provisioning',
    jsonb_build_object('seed_file','supabase/seed/seed.sql','bundle_id','fintech-stack','admin_email','admin@example.com'),
    'info', now()
  );

  RAISE NOTICE '';
  RAISE NOTICE '=================================================================';
  RAISE NOTICE 'SEED COMPLETE';
  RAISE NOTICE 'Tenant ID   : %', v_tenant_id;
  RAISE NOTICE 'Tenant slug : acme-corp-seed';
  RAISE NOTICE 'Bundle      : fintech-stack';
  RAISE NOTICE 'Admin email : admin@example.com';
  RAISE NOTICE '=================================================================';
  RAISE NOTICE 'NEXT STEP: Replace v_admin_auth_id placeholder with real';
  RAISE NOTICE 'auth.users.id from Supabase Auth Dashboard, then re-run seed.';
  RAISE NOTICE '=================================================================';

END $$;
