# syntax=docker/dockerfile:experimental
# Use ubuntu 20.04 as base image
FROM ubuntu:20.04

# Define the folder /code as the main working directory
WORKDIR /code

# ===============================
# Install Python3.10 
# ===============================
# Install python3.10. Since ubuntu 20.04 only has python3.8 by default, we need to add some addtional ppa's to install python3.10
RUN apt-get update && apt install -y software-properties-common
# Add deadsnakes ppa which contains python3.10 for ubuntu 20.04
RUN add-apt-repository -y ppa:deadsnakes/ppa
# Install python3.10
RUN apt update && apt install -y python3.10 python3.10-distutils python3.10-dev
# Make sure python and python3 point to python3.10, and not the system default python3.8
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# ===============================
# Install common dependencies
# ===============================
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    wget \
    ccache \
    assimp-utils \
    build-essential \
    cmake \
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
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    software-properties-common \
    net-tools \
    virtualenv \
    wget \
    xpra \
    patchelf \
    xserver-xorg-dev \
    apt-transport-https \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ===============================
# Install Python dependencies
# Specified in the requirements.txt file
# ===============================
# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

# This is needed to make mujoco_py work. Somehow Cython 3.0 breaks it. So downgrade it
RUN pip install "Cython<3"
RUN pip install numpy --force-reinstall

# Copy the requirements.txt file to the container
COPY requirements.txt .
# Install the dependencies
RUN python3 -m pip install -r requirements.txt

# ===============================
# Install Mujoco v210
# ===============================
RUN wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz
RUN mkdir /root/.mujoco
RUN tar -xf mujoco210-linux-x86_64.tar.gz --directory /root/.mujoco
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.mujoco/mujoco210/bin

# Trigger mujoco_py compilation
RUN python -c "import mujoco_py"
