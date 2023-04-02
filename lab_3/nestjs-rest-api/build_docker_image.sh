#!/usr/bin/env bash

docker build -t lab-3-container:v$1 .
docker login
docker push lab-3-container:v$1

#docker run -d -p80:3000 test-container:v$1
