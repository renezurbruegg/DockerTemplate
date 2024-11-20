# syntax=docker/dockerfile:experimental
FROM osrf/ros:noetic-desktop-full

ARG MAKE_JOBS=6


ENV CTEST_PARALLEL_LEVEL=$MAKE_JOBS CTEST_OUTPUT_ON_FAILURE=true DEBIAN_FRONTEND=noninteractive \
    CMAKE_OPTS="-DBUILD_PYTHON_INTERFACE=OFF \
                -DCMAKE_INSTALL_LIBDIR=lib \
                -DCMAKE_INSTALL_PREFIX=/usr \
                -DBUILD_TESTING=ON \
                -DCMAKE_BUILD_TYPE=Release"




WORKDIR /code

# PYTHON DEPENDENCIES
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    assimp-utils \
    build-essential \
    cmake \
    curl \
    git \
    libassimp-dev \
    libboost-all-dev \
    libccd-dev \
    libeigen3-dev \
    liboctomap-dev \
    libtinyxml-dev \
    liburdfdom-dev \
    libsasl2-dev \
    libgmp3-dev \
    libsnmp-dev \
    ros-noetic-plotjuggler\
    python3-tk\
    python3-rosdep\
    ros-noetic-realsense2-camera\
    ros-noetic-graph-msgs \
    apt-transport-https\
    ccache\
    && rm -rf /var/lib/apt/lists/*


# INSTALL librealsense

RUN mkdir -p /etc/apt/keyrings
RUN curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | tee /etc/apt/keyrings/librealsense.pgp > /dev/null

RUN echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo `lsb_release -cs` main" | tee /etc/apt/sources.list.d/librealsense.list

RUN apt-get update && apt-get install -y \
    librealsense2-dkms \
    librealsense2-utils \
    && rm -rf /var/lib/apt/lists/*


RUN python3 -m pip install --upgrade pip

COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

# CACHING FOR PIP
# Note: This makes re-building of images a LOT quicker since we do not need to
# download all pip packages again and again.
ENV PIP_CACHE_DIR=/root/.cache/pip
RUN mkdir -p $PIP_CACHE_DIR

RUN rosdep update
RUN \
    # Update apt package list as previous containers clear the cache
    apt-get -q update && \
    apt-get -q -y dist-upgrade

RUN apt-get install -y \
    python3-wstool\
    python3-catkin-tools\
    ros-noetic-rosparam-shortcuts \
    && rm -rf /var/lib/apt/lists/*
