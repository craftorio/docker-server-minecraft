#!/bin/bash

docker build -f Dockerfile-1165-mohist-magma --squash --build-arg MC_RELEASE_TAG=1.16.5 --build-arg MC_SERVER_TAG=mohist-1.16.5-1033 -t craftorio/docker-server-minecraft:mohist-1.16.5-1033 .
docker push craftorio/docker-server-minecraft:mohist-1.16.5-1033
