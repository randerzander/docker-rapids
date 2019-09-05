# An integration test & dev container which builds and installs RAPIDS from latest source branches
ARG CUDA_VERSION=10.0
ARG LINUX_VERSION=ubuntu18.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-${LINUX_VERSION}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
# Needed for promptless tzdata install
ENV DEBIAN_FRONTEND=noninteractive

ARG CC=7
ARG CXX=7
RUN apt update -y --fix-missing && \
    apt upgrade -y && \
      apt install -y \
      git \
      gcc-${CC} \
      g++-${CXX} \
      tzdata \
      locales \
      openjdk-8-jdk \
      vim

ADD Miniconda3-latest-Linux-x86_64.sh /miniconda.sh
RUN sh /miniconda.sh -b -p /conda && /conda/bin/conda update -n base conda
ENV PATH=${PATH}:/conda/bin
# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

# Build cuDF conda env
ENV CONDA_ENV=rapids
ADD conda /rapids/conda/environments
RUN conda env create --name ${CONDA_ENV} --file /rapids/conda/environments/rapids_dev.yml
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/conda/envs/${CONDA_ENV}/lib

RUN source activate ${CONDA_ENV} && conda env update --name ${CONDA_ENV} -f=/rapids/conda/environments/useful_packages.yml

ENV PYNI_PATH=/conda/envs/${CONDA_ENV}
ENV PYTHON_VERSION=3.7
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV CC=/usr/bin/gcc-${CC}
ENV CXX=/usr/bin/g++-${CXX}
ENV CMAKE_CXX11_ABI=ON

WORKDIR /notebooks
CMD source activate ${CONDA_ENV} && bash /rapids/build.sh && jupyter-lab --allow-root --ip='0.0.0.0' --NotebookApp.token=''
