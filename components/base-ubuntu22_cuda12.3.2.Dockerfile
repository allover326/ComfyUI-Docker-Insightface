FROM nvidia/cuda:12.3.2-runtime-ubuntu22.04

# Here, we are using CUDNN8 (devel) -- CUDNN9 is also compatible for CUDA 12.3
# Adapted from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.2.2/ubuntu2204/devel/cudnn8/Dockerfile
ENV NV_CUDNN_VERSION=8.9.7.29
ENV NV_CUDNN_PACKAGE_NAME="libcudnn8"
ENV NV_CUDA_ADD=cuda12.2
ENV NV_CUDNN_PACKAGE="$NV_CUDNN_PACKAGE_NAME=$NV_CUDNN_VERSION-1+$NV_CUDA_ADD"
ENV NV_CUDNN_PACKAGE_DEV="$NV_CUDNN_PACKAGE_NAME-dev=$NV_CUDNN_VERSION-1+$NV_CUDA_ADD"
LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/*

ARG BASE_DOCKER_FROM=nvidia/cuda:12.3.2-runtime-ubuntu22.04

