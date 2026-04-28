# Supabase Setup

## Quick Start

1. Run migrations in order:
   ```bash
   supabase db push   # applies all migrations in supabase/migrations/
   ```

2. Seed the first tenant:
   - Create an admin user in [Supabase Auth Dashboard](https://supabase.com/dashboard)
   - Copy their UUID into `supabase/seed/seed.sql` (replace `v_admin_auth_id` placeholder)
   - Run:
   ```bash
   psql "$(supabase db url)" -f supabase/seed/seed.sql
   ```

3. Set env vars in your app (see docs/supabase/SETUP.md)

## Migrations

| File | Purpose |
|------|---------|
| `0001_core.sql` | Core tables, enums, indexes |
| `0002_rls.sql` | RLS enablement + admin-only policies |

## Security Model

- All tables are RLS-protected.
- `is_tenant_admin(tenant_id)` is the central policy function.
- Only `tenant_memberships.role = 'admin'` rows with `status = 'active'` can access data.
- `user_id` in memberships MUST be `auth.uid()` — never rely on email for RLS.
