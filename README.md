# Supabase PROD - Self-Hosted

Setup completo do Supabase para produção.

## Portas (somente 127.0.0.1 no servidor: use tunel SSH)
- 5433 - Postgres
- 9998 - Auth (GoTrue)
- 3002 - Studio (UI Admin)
- 3003 - REST (PostgREST)

Ex.: `ssh -L 3002:127.0.0.1:3002 root@<servidor>` e abra http://localhost:3002

## Acesso publico (Traefik)
- `api.cabratech.cloud` - Kong. Todo pedido exige o header `apikey` (ANON_KEY ou
  SERVICE_ROLE_KEY; o supabase-js envia sozinho). `/pg` (postgres-meta) so aceita
  a SERVICE_ROLE_KEY.
- `studio.cabratech.cloud` - Studio, atras de Basic Auth (`STUDIO_BASIC_AUTH`).
- `auth.cabratech.cloud` - GoTrue direto.

## Stack
- DB: supabase/postgres:15.19.0.004
- Auth: supabase/gotrue:v2.172.1
- REST: postgrest/postgrest:v12.2.12
- Meta: supabase/postgres-meta:v0.89.0
- Studio: supabase/studio:2025.05.19-sha-3487831

## ⚠️ IMPORTANTE: PRODUÇÃO
- Senha padrão é `supabase` — **MUDE** nas envs do Coolify
- Configure firewall (não exponha porta 5433/9998/3002/3003 na internet)
- Configure domínio + SSL (Traefik do Coolify já dá suporte)
- Faça backup regular do volume `db-data`

## Como funciona
- `initdb.d/00-create-roles.sql` cria `supabase_admin`
- Scripts OFICIAIS da imagem (em init-scripts/ e migrations/) rodam depois
- Após init, é necessário setar manualmente as senhas das roles reserved

## Fix pós-deploy
```sql
ALTER USER supabase_auth_admin WITH PASSWORD 'supabase';
ALTER USER supabase_storage_admin WITH PASSWORD 'supabase';
ALTER USER authenticator WITH PASSWORD 'supabase';
ALTER USER pgbouncer WITH PASSWORD 'supabase';
```

## Variáveis de ambiente (Coolify)
- `POSTGRES_PASSWORD` - senha do DB (TROCAR!)
- `JWT_SECRET` - secret dos tokens
- `SITE_URL` - URL do site
- `API_EXTERNAL_URL` - URL do auth
- `SUPABASE_URL` - URL do REST
- `SUPABASE_PUBLIC_URL` - URL pública
- `PG_META_CRYPTO_KEY` - chave de criptografia do Meta
- `ANON_KEY` - JWT anon
- `SERVICE_ROLE_KEY` - JWT service_role
- `STUDIO_DEFAULT_ORGANIZATION` - "Xuxu Prod"
- `STUDIO_DEFAULT_PROJECT` - "supabase-prod"
- `STUDIO_BASIC_AUTH` - login do Studio no formato htpasswd: `htpasswd -nbB admin 'senha'`
  (no Coolify, marque a variavel como literal: o hash tem `$`)
