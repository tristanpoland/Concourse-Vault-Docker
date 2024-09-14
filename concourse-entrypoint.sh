#!/bin/sh
set -e

echo "Starting Concourse entrypoint script..."

echo "Waiting for Vault credentials..."
until [ -f /vault/file/role_id ] && [ -f /vault/file/secret_id ]; do
  echo "Waiting for Vault credentials..."
  ls -l /vault/file
  sleep 5
done

echo "Reading Vault credentials..."
ROLE_ID=$(cat /vault/file/role_id)
SECRET_ID=$(cat /vault/file/secret_id)

echo "Vault credentials:"
echo "Role ID: $ROLE_ID"
echo "Secret ID: $SECRET_ID"

echo "Vault credentials read successfully."

# echo "Testing Vault connection..."
# curl -s -X POST -d "{\"role_id\":\"$ROLE_ID\",\"secret_id\":\"$SECRET_ID\"}" http://vault:8200/v1/auth/approle/login

echo "Exporting Vault credentials..."
export CONCOURSE_VAULT_AUTH_PARAM="role_id=${ROLE_ID},secret_id=${SECRET_ID}"

echo "Vault credentials set. CONCOURSE_VAULT_AUTH_PARAM is now set (value hidden for security)"

echo "Starting Concourse web..."
exec /usr/local/bin/entrypoint.sh web
