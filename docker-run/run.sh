#!/bin/bash

export TULEAP_FQDN="tuleap.example.com"
export MYSQL_ROOT_PASSWORD="somerandomstrongPassword123!"
export TULEAP_SYS_DBPASSWD="anotherstrongPassword"
export SITE_ADMINISTRATOR_PASSWORD="andathirdstrongPassword123!"

# Create a custom bridge network
docker network create tuleap_network

# Start the database container on the custom network
docker run -d \
  --name tuleap-db \
  --network tuleap_network \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -v db-data:/var/lib/mysql \
  --hostname db \
  mysql:8.0 \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_unicode_ci \
  --sql-mode=NO_ENGINE_SUBSTITUTION

# Start the Redis container on the custom network
docker run -d \
  --name tuleap-redis \
  --network tuleap_network \
  -v redis-data:/data \
  --hostname redis \
  redis:6 \
  redis-server --appendonly yes --auto-aof-rewrite-percentage 20 --auto-aof-rewrite-min-size 200kb

# Wait for a short time to ensure that the database and Redis containers are started
sleep 15

# Start the Tuleap web container on the custom network
docker run -d \
  --name tuleap-web \
  --hostname ${TULEAP_FQDN} \
  --network tuleap_network \
  -p 80:80 -p 443:443 -p 2222:22 \
  -v tuleap-data:/data \
  --restart always \
  -e TULEAP_FQDN=${TULEAP_FQDN} \
  -e TULEAP_SYS_DBHOST=db \
  -e TULEAP_SYS_DBPASSWD=${TULEAP_SYS_DBPASSWD} \
  -e SITE_ADMINISTRATOR_PASSWORD=${SITE_ADMINISTRATOR_PASSWORD} \
  -e DB_ADMIN_USER=root \
  -e DB_ADMIN_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -e TULEAP_FPM_SESSION_MODE=redis \
  -e TULEAP_REDIS_SERVER=redis \
  tuleap/tuleap-community-edition:stable-15.0
