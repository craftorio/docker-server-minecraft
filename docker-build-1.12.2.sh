#!/bin/bash

docker build -f Dockerfile-1122-forge --squash --build-arg MC_RELEASE_TAG=1.12.2 --build-arg MC_SERVER_TAG=forge-1.12.2-2860 -t craftorio/docker-server-minecraft:forge-1.12.2-2860 .
