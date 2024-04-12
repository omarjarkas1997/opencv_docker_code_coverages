#!/bin/bash

# Build the Docker image
docker build -t opencv-python-release .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully."
else
    echo "Failed to build Docker image."
    exit 1
fi
