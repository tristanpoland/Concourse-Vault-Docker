#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER concourse WITH PASSWORD 'concourse_pass';
    CREATE DATABASE concourse;
    GRANT ALL PRIVILEGES ON DATABASE concourse TO concourse;
EOSQL
