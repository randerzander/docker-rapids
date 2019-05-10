# An integration test & dev container which builds and installs RAPIDS from latest source branches
ARG CUDA_VERSION=10.0
ARG LINUX_VERSION=ubuntu16.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-${LINUX_VERSION} as BASE
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
# Needed for cudf.concat(), avoids "OSError: library nvvm not found"
ENV NUMBAPRO_NVVM=/usr/local/cuda/nvvm/lib64/libnvvm.so
ENV NUMBAPRO_LIBDEVICE=/usr/local/cuda/nvvm/libdevice/
# Needed for promptless tzdata install
ENV DEBIAN_FRONTEND=noninteractive

ARG CC=6
ARG CXX=6
RUN apt update -y --fix-missing && \
    apt upgrade -y && \
      apt install -y \
      git \
      gcc \
      g++ \
      libboost-all-dev \
      tzdata \
      locales

# Install conda
#ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh /miniconda.sh
ADD Miniconda3-latest-Linux-x86_64.sh /miniconda.sh
RUN sh /miniconda.sh -b -p /conda && /conda/bin/conda update -n base conda
ENV PATH=${PATH}:/conda/bin
# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

# Build cuDF conda env
ENV CONDA_ENV=rapids
ADD conda /conda/environments
RUN conda env create --name ${CONDA_ENV} --file /conda/environments/rapids_dev.yml

# useful user-level customizations
RUN source activate ${CONDA_ENV} && conda env update --name ${CONDA_ENV} -f=/conda/environments/useful_packages.yml

WORKDIR /notebooks
CMD source activate ${CONDA_ENV} && jupyter-lab --allow-root --ip='0.0.0.0' --NotebookApp.token=''
