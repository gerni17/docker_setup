#!/bin/bash
# Installation of CUDA for Jetson devices
set -e
echo "Installing CUDA packages..."
echo "  WITH_CUDA:       $WITH_CUDA"
echo "  CUDA_VERSION:    $CUDA_VERSION"
echo "  CUDA_ARCH_BIN:   $JETPACK_VERSION"
echo "  JETPACK_VERSION: $JETPACK_VERSION"
echo "  ROS_VERSION:     $ROS_VERSION"

if [[ "$WITH_CUDA" != "" && "$JETPACK_VERSION" != "" ]]; then
    if [[ "$JETPACK_VERSION" == "r32.5.0" ]]; then
        # Get public key
        sudo apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
        
        # Manually add apt
        touch /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
        echo "deb https://repo.download.nvidia.com/jetson/common r32.5 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
        echo "deb https://repo.download.nvidia.com/jetson/t194 r32.5 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

    elif [[ "$JETPACK_VERSION" == "r34.1.1" ]]; then
        # Get public key
        sudo apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
        
        # Manually add apt
        touch /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
        echo "deb https://repo.download.nvidia.com/jetson/common r34.1 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
        echo "deb https://repo.download.nvidia.com/jetson/t194 r34.1 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

    else
        echo "Not supported Jetpack version [$JETPACK_VERSION]"
        exit 1
    fi

    # Update apt
    apt update

    # Install CUDA
    apt install -y --no-install-recommends cuda-toolkit-*
    # Install CUDNN
    apt install -y --no-install-recommends libcudnn*-dev
    # Install VPI
    apt install -y --no-install-recommends vpi2-dev \
                                           vpi2-samples \
                                           python3.8-vpi2
    # Install TensorRT
    apt install -y --no-install-recommends tensorrt \
		                                   python3-libnvinfer-dev
    

    # Export paths
    echo "export PATH=/usr/local/cuda/bin:$PATH" >> /root/.bashrc
    echo "export CPATH=/usr/local/cuda/include:$CPATH" >> /root/.bashrc
    echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH" >> /root/.bashrc
    echo "export CUDA_HOME=/usr/local/cuda" >> /root/.bashrc
    echo "export CUDA_PATH=/usr/local/cuda" >> /root/.bashrc
    echo "export TORCH_CUDA_ARG_LIST=$CUDA_ARCH_BIN" >> /root/.bashrc
    echo "export CUDA_ARCH_BIN=$CUDA_ARCH_BIN" >> /root/.bashrc
    source /root/.bashrc

    # Remove apt repos
    rm -rf /var/lib/apt/lists/*
    apt-get clean
fi