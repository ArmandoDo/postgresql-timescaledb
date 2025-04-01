#!/bin/bash
set -ex

# Wait until postgres is ready
until pg_isready -U postgres; do
  sleep 1
done

# Create new users
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "development" <<-EOSQL
    CREATE USER admin WITH ENCRYPTED PASSWORD '${ADMIN_PASSWORD}';
    ALTER USER admin WITH SUPERUSER;
EOSQL
