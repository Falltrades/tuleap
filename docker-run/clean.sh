#!/bin/bash

docker stop tuleap-web tuleap-redis tuleap-db
docker rm tuleap-web tuleap-redis tuleap-db
docker volume rm db-data redis-data tuleap-data
docker network rm tuleap_network
