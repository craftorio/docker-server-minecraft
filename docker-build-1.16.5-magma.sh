#!/bin/bash

docker build -f Dockerfile-1165-mohist-magma --squash --build-arg MC_RELEASE_TAG=1.16.5 --build-arg MC_SERVER_TAG=magma-1.16.5-36.2.35 -t craftorio/docker-server-minecraft:magma-1.16.5-36.2.35 .
docker push craftorio/docker-server-minecraft:magma-1.16.5-36.2.35
