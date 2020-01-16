# An integration test & dev container which installs RAPIDS from latest nightly conda packages
ARG CUDA_VERSION=10.1
ARG LINUX_VERSION=ubuntu18.04
FROM nvidia/cuda:${CUDA_VERSION}-runtime-${LINUX_VERSION} as BASE
ENV DEBIAN_FRONTEND=noninteractive

ARG CC=6
ARG CXX=6
RUN apt update -y --fix-missing && \
    apt upgrade -y && \
      apt install -y \
      tzdata \
      locales \
      vim \
      libnuma-dev libibverbs-dev librdmacm-dev \
      git

# Install conda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh /miniconda.sh
RUN sh /miniconda.sh -b -p /conda
ENV PATH=${PATH}:/conda/bin
# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

# Build cuDF conda env
ENV CONDA_ENV=rapids

# useful user-level customizations
ADD /conda/useful_packages.yml /conda/environments/useful_packages.yml
RUN conda env create --name ${CONDA_ENV} -f /conda/environments/useful_packages.yml
RUN source activate ${CONDA_ENV} && jupyter labextension install dask-labextension
RUN source activate ${CONDA_ENV} && jupyter labextension install jupyterlab-nvdashboard

# install RAPIDS packages
ADD /conda/rapids_dev.yml /conda/environments/rapids_dev.yml
RUN source activate ${CONDA_ENV} && conda env update -f /conda/environments/rapids_dev.yml

# ucx env var for plain TCP, no nvlink
#ENV UCX_TLS=tcp,sockcm
# ucx env var for nvlink
#ENV UCX_TLS=tcp,sockcm,cuda_copy,cuda_ipc
#ENV UCX_SOCKADDR_TLS_PRIORITY=sockcm
#ENV UCXPY_IFNAME="enp1s0f0"

CMD source activate ${CONDA_ENV} && jupyter-lab --allow-root --ip='0.0.0.0' --NotebookApp.token='' --NotebookApp.notebook_dir='/notebooks'
