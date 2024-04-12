# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    cmake \
    pkg-config \
    libopencv-dev \
    gcc \
    g++ \
    lcov \
    python3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer1.0-dev \
    libgtk2.0-dev \
    libgtk-3-dev \
    libpng-dev \
    libjpeg-dev \
    libopenexr-dev \
    libtiff-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the opencv-python repository with all submodules
RUN git clone --recursive https://github.com/opencv/opencv-python.git

# Set working directory to the OpenCV build directory in the opencv-python submodule
WORKDIR /app/opencv-python/opencv/build

# Build OpenCV with coverage flags
RUN cmake -D CMAKE_BUILD_TYPE=Debug \
    -D CMAKE_CXX_FLAGS="--coverage -fPIC" \
    -D CMAKE_C_FLAGS="--coverage -fPIC" \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_opencv_python3=ON \
    -D PYTHON_EXECUTABLE=$(which python) \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    ../
RUN make -j$(nproc)
RUN make install

# Prepare environment for Python bindings
ENV OpenCV_DIR=/app/opencv-python/opencv/build


# Switch back to the opencv-python directory to build Python bindings
WORKDIR /app/opencv-python

# Install numpy before building OpenCV Python bindings
RUN pip install numpy pandas openpyxl scikit-build



# Set environment variables to enable verbose makefile and debug mode
ENV CMAKE_ARGS='-DCMAKE_VERBOSE_MAKEFILE=ON'
ENV VERBOSE=1

# Build OpenCV Python bindings
RUN python3 setup.py bdist_wheel --build-type=Debug

# Install the Python bindings
RUN pip install dist/*.whl

# Switch back to the app directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Open a Bash shell when the container launches
CMD ["bash"]
