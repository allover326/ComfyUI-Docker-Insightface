FROM nvidia/cuda:12.5.1-runtime-ubuntu24.04

# Extended from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.5.1/ubuntu2404/runtime/Dockerfile
ENV NV_CUDNN_VERSION=9.3.0.75-1
ENV NV_CUDNN_PACKAGE_NAME="libcudnn9"
ENV NV_CUDA_ADD=cuda-12
ENV NV_CUDNN_PACKAGE="$NV_CUDNN_PACKAGE_NAME-$NV_CUDA_ADD=$NV_CUDNN_VERSION"

LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
  ${NV_CUDNN_PACKAGE} \
  && apt-mark hold ${NV_CUDNN_PACKAGE_NAME}-${NV_CUDA_ADD}

ARG BASE_DOCKER_FROM=nvidia/cuda:12.5.1-runtime-ubuntu24.04

