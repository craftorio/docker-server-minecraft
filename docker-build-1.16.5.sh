#!/bin/bash

docker build -f Dockerfile-116 --squash --build-arg MC_RELEASE_TAG=1.16.5 --build-arg MC_SERVER_TAG=mohist-1.16.5-835 -t craftorio/docker-server-minecraft:mohist-1.16.5-835 .
