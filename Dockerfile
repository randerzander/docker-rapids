# An integration test & dev container which builds and installs RAPIDS from latest source branches
ARG CUDA_VERSION=9.2
ARG LINUX_VERSION=ubuntu18.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-${LINUX_VERSION} as BASE
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
# Needed for cudf.concat(), avoids "OSError: library nvvm not found"
ENV NUMBAPRO_NVVM=/usr/local/cuda/nvvm/lib64/libnvvm.so
ENV NUMBAPRO_LIBDEVICE=/usr/local/cuda/nvvm/libdevice/
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
ADD rapids_dev.yml /conda/environments/rapids_dev.yml
RUN conda env create --name ${CONDA_ENV} --file /conda/environments/rapids_dev.yml

# Added here to prevent re-downloading after changes to custrings, cudf, cugraph src, etc
RUN source activate ${CONDA_ENV} && conda install -c conda-forge \
    jupyterlab bokeh s3fs cmake scikit-learn scipy

FROM BASE as CONDA

ENV CC=/usr/bin/gcc-7
ENV CXX=/usr/bin/g++-7

# Must build/install xgboost from source for cudf-interop
ADD rapidsai-xgboost /xgboost
WORKDIR /xgboost
RUN source activate ${CONDA_ENV} && \
    mkdir -p /xgboost/build && cd /xgboost/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
          -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
          -DUSE_CUDF=ON -DCMAKE_CXX11_ABI=ON \
          -DUSE_CUDA=ON -DUSE_NCCL=ON && \
    make -j && \
    cd /xgboost/python-package && \
    python setup.py bdist_wheel && \
    pip install /xgboost/python-package/dist/xgboost*.whl

ADD dask-xgboost /dask-xgboost
WORKDIR /dask-xgboost
RUN source activate ${CONDA_ENV} && python setup.py install

WORKDIR /notebooks
CMD source activate ${CONDA_ENV} && jupyter-lab --allow-root --ip='0.0.0.0' --NotebookApp.token=''
