#!/bin/bash
set -e

# export PGPASSWORD="changeme"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE testdb;
    CREATE USER testdba WITH PASSWORD 'secret';
    GRANT ALL PRIVILEGES ON DATABASE testdb TO testdba;
EOSQL
