sudo chmod -R +x ./*

exec ./gen-keys.sh
docker-compose up -d
