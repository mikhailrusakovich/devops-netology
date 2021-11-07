#!/bin/bash
app_image="docker.test"
container_name="app_container"
docker build -t ${app_image} .
docker run -d -p 8080:5000 \
  --name=${container_name} \
  -v $PWD:/app ${container_name}