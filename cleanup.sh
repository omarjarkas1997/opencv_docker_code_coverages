#!/bin/bash

# Stop all containers based on the opencv-python-release image
docker ps -q --filter "ancestor=opencv-python-release" | xargs -r docker stop

# Remove all containers based on the opencv-python-release image
docker ps -aq --filter "ancestor=opencv-python-release" | xargs -r docker rm

# Remove the Docker image
docker rmi opencv-python-release
