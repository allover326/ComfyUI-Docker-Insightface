FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

# CUDNN9 "runtime" package
# Adapted from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.4.1/ubuntu2204/runtime/cudnn/Dockerfile
ENV NV_CUDNN_VERSION=9.1.0.70-1
ENV NV_CUDNN_PACKAGE_NAME=libcudnn9-cuda-12
ENV NV_CUDNN_PACKAGE="libcudnn9-cuda-12=${NV_CUDNN_VERSION}"

LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/*

ARG BASE_DOCKER_FROM=nvidia/cuda:12.4.1-runtime-ubuntu22.04

