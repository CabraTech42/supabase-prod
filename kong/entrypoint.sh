#!/bin/sh
# Gera o kong.yml final a partir do template, trocando os marcadores pelas chaves
# (JWTs: so letras, numeros, ".", "-" e "_", seguros no sed).
set -e
if [ -z "$SUPABASE_ANON_KEY" ] || [ -z "$SUPABASE_SERVICE_KEY" ]; then
  echo "kong: ANON_KEY e SERVICE_ROLE_KEY precisam estar definidas" >&2
  exit 1
fi
sed -e "s|\$SUPABASE_ANON_KEY|$SUPABASE_ANON_KEY|g" \
    -e "s|\$SUPABASE_SERVICE_KEY|$SUPABASE_SERVICE_KEY|g" \
    /kong/kong.yml > /tmp/kong.yml
exec /docker-entrypoint.sh kong docker-start
