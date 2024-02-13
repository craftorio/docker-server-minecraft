#!/bin/bash
MC_DOCKER_IMG="craftorio/docker-server-minecraft"
MC_SERVER_TAG=arclight-forge-1.18.2-1.0.11
docker build -f Dockerfile-1182-arclight-forge --squash -t ${MC_DOCKER_IMG}:${MC_SERVER_TAG} \
--build-arg MC_RELEASE_TAG=1.18.2 --build-arg MC_SERVER_TAG=${MC_SERVER_TAG}  .
docker push ${MC_DOCKER_IMG}:${MC_SERVER_TAG}
