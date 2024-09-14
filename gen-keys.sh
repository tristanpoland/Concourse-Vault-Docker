#!/bin/sh
mkdir -p keys/web keys/worker

# Generate keys using concourse CLI
docker run --rm -v $PWD/keys/web:/keys concourse/concourse generate-key -t rsa -f /keys/session_signing_key
docker run --rm -v $PWD/keys/web:/keys concourse/concourse generate-key -t ssh -f /keys/tsa_host_key
docker run --rm -v $PWD/keys/worker:/keys concourse/concourse generate-key -t ssh -f /keys/worker_key

# Set correct permissions
chmod 600 keys/web/*
chmod 600 keys/worker/*

# Copy public keys
cp keys/worker/worker_key.pub keys/web/authorized_worker_keys
cp keys/web/tsa_host_key.pub keys/worker
