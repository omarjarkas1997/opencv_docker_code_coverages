# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    cmake \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCV Python and gcovr
RUN pip install --no-cache-dir opencv-python gcovr

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Open a Bash shell when the container launches
CMD ["bash"]
