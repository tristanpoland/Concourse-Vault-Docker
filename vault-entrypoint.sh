#!/bin/sh
set -e

echo "Starting Vault server..."
vault server -dev -dev-root-token-id=root &

echo "Waiting for Vault to start..."
sleep 5

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

echo "Enabling AppRole auth method..."
vault auth enable approle

echo "Creating policy for Concourse..."
vault policy write concourse - <<EOF
path "concourse/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

echo "Creating AppRole for Concourse..."
vault write auth/approle/role/concourse policies="concourse"

echo "Getting role_id and secret_id..."
ROLE_ID=$(vault read -field=role_id auth/approle/role/concourse/role-id)
SECRET_ID=$(vault write -field=secret_id -f auth/approle/role/concourse/secret-id)

echo "Writing role_id and secret_id to files..."
echo $ROLE_ID > /vault/file/role_id
echo $SECRET_ID > /vault/file/secret_id

echo "Vault initialization completed. Credentials:"
echo "Role ID: $(cat /vault/file/role_id)"
echo "Secret ID: $(cat /vault/file/secret_id)"

echo "Keeping container running..."
wait
