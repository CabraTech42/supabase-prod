-- Cria APENAS supabase_admin (que o migrate.sh oficial precisa)
-- Outras roles (anon, authenticated, etc) são criadas pelos scripts OFICIAIS
-- Schema extensions também (necessário pro webhooks.sql)

ALTER ROLE postgres WITH SUPERUSER;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='supabase_admin') THEN
    CREATE ROLE supabase_admin WITH LOGIN PASSWORD 'supabase' BYPASSRLS SUPERUSER;
  END IF;
END
$$;

CREATE SCHEMA IF NOT EXISTS extensions;
