wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost

git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop rapidsai-xgboost
cd rapidsai-xgboost && git submodule update --init --recursive -- dmlc-core

cd ..
