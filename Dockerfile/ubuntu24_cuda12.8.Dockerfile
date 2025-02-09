FROM nvidia/cuda:12.8.0-runtime-ubuntu24.04

# Adapted from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.8.0/ubuntu2404/devel/cudnn/Dockerfile
ENV NV_CUDNN_VERSION=9.7.0.66-1
ENV NV_CUDNN_PACKAGE_NAME="libcudnn9-cuda-12"
ENV NV_CUDNN_PACKAGE="libcudnn9-cuda-12=${NV_CUDNN_VERSION}"

LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME}

ARG BASE_DOCKER_FROM=nvidia/cuda:12.8.0-runtime-ubuntu24.04
##### Base

# Install system packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y --fix-missing\
  && apt-get install -y \
    apt-utils \
    locales \
    ca-certificates \
    && apt-get upgrade -y \
    && apt-get clean

# UTF-8
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8
ENV LC_ALL=C

# Install needed packages
RUN apt-get update -y --fix-missing \
  && apt-get upgrade -y \
  && apt-get install -y \
    build-essential \
    python3-dev \
    unzip \
    wget \
    zip \
    zlib1g \
    zlib1g-dev \
    gnupg \
    rsync \
    python3-pip \
    python3-venv \
    git \
    sudo \
    # Adding libGL (used by a few common nodes)
    libgl1 \
    libglib2.0-0 \
    # Adding FFMPEG (for video generation workflow)
    ffmpeg \
  && apt-get clean

ENV BUILD_FILE="/etc/image_base.txt"
ARG BASE_DOCKER_FROM
RUN echo "DOCKER_FROM: ${BASE_DOCKER_FROM}" | tee ${BUILD_FILE}
RUN echo "CUDNN: ${NV_CUDNN_PACKAGE_NAME} (${NV_CUDNN_VERSION})" | tee -a ${BUILD_FILE}

ARG BUILD_BASE="unknown"
LABEL comfyui-nvidia-docker-build-from=${BUILD_BASE}
RUN it="/etc/build_base.txt"; echo ${BUILD_BASE} > $it && chmod 555 $it

##### ComfyUI preparation
# The comfy user will have UID 1024 and GID 1024
ENV COMFYUSER_DIR="/comfy"
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && useradd -u 1024 -U -d ${COMFYUSER_DIR} -s /bin/bash -m comfy \
    && usermod -G users comfy \
    && adduser comfy sudo \
    && test -d ${COMFYUSER_DIR}
RUN it="/etc/comfyuser_dir"; echo ${COMFYUSER_DIR} > $it && chmod 555 $it

ENV NVIDIA_VISIBLE_DEVICES=all

EXPOSE 8188

USER comfy
WORKDIR ${COMFYUSER_DIR}
COPY --chown=comfy:comfy --chmod=555 init.bash comfyui-nvidia_init.bash

ARG BUILD_DATE="unknown"
LABEL comfyui-nvidia-docker-build=${BUILD_DATE}

CMD [ "./comfyui-nvidia_init.bash" ]
