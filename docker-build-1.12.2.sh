#!/bin/bash

docker build -f Dockerfile-112 --squash --build-arg MC_RELEASE_TAG=1.12.2 --build-arg MC_SERVER_TAG=1.12.2-2860 -t craftorio/docker-server-minecraft:1.12.2-2860 .
