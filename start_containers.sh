#!/bin/bash

docker compose up -d
docker exec -it manager_container /bin/sh
