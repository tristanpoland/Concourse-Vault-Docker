@echo off
mkdir keys\web keys\worker

REM Generate keys using concourse CLI
docker run --rm -v %CD%\keys\web:/keys concourse/concourse generate-key -t rsa -f /keys/session_signing_key
docker run --rm -v %CD%\keys\web:/keys concourse/concourse generate-key -t ssh -f /keys/tsa_host_key
docker run --rm -v %CD%\keys\worker:/keys concourse/concourse generate-key -t ssh -f /keys/worker_key

REM Set correct permissions (Note: Windows doesn't have a direct equivalent to chmod 600)
REM Instead, we'll use icacls to set similar permissions

icacls keys\web\* /inheritance:r
icacls keys\web\* /grant:r %USERNAME%:(R,W)
icacls keys\worker\* /inheritance:r
icacls keys\worker\* /grant:r %USERNAME%:(R,W)

REM Copy public keys
copy keys\worker\worker_key.pub keys\web\authorized_worker_keys
copy keys\web\tsa_host_key.pub keys\worker