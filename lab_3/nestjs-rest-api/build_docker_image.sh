#!/usr/bin/env bash

docker build -t test-container:v$1 .
docker login
docker push test-container:v$1

#docker run -d -p80:3000 test-container:v$1
