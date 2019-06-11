# An integration test & dev container which installs RAPIDS from latest nightly conda packages
ARG CUDA_VERSION=10.0
ARG LINUX_VERSION=ubuntu18.04
FROM nvidia/cuda:${CUDA_VERSION}-runtime-${LINUX_VERSION} as BASE
ENV DEBIAN_FRONTEND=noninteractive

ARG CC=6
ARG CXX=6
RUN apt update -y --fix-missing && \
    apt upgrade -y && \
      apt install -y \
      tzdata \
      locales

# Install conda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh /miniconda.sh
RUN sh /miniconda.sh -b -p /conda && /conda/bin/conda update -n base conda
# Install mamba
#ADD https://github.com/QuantStack/mamba/releases/download/0.0.7/minimamba-0.0.7-Linux-x86_64-py37.sh /minimamba.sh
#RUN sh /minimamba.sh -b -p /conda && /conda/bin/mamba update -n base conda
ENV PATH=${PATH}:/conda/bin
# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

# Build cuDF conda env
ENV CONDA_ENV=rapids
ADD /conda/base.yml /conda/environments/base.yml
RUN conda env create --name ${CONDA_ENV} --file /conda/environments/base.yml

# useful user-level customizations
ADD /conda/useful_packages.yml /conda/environments/useful_packages.yml
RUN source activate ${CONDA_ENV} && mamba env update -f /conda/environments/useful_packages.yml

# install RAPIDS packages
ADD /conda/rapids_dev.yml /conda/environments/rapids_dev.yml
RUN source activate ${CONDA_ENV} && mamba env update -f /conda/environments/rapids_dev.yml

WORKDIR /notebooks
CMD source activate ${CONDA_ENV} && jupyter-lab --allow-root --ip='0.0.0.0' --NotebookApp.token=''
