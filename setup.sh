wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

git clone --recurse-submodules https://github.com/rapidsai/custrings
#git clone --recurse-submodules https://github.com/rapidsai/cudf
# cloning directly from strings WIP pr
git clone --recurse-submodules https://github.com/kkraus14/cudf -b fea-ext-string-support

git clone --recurse-submodules https://github.com/rapidsai/cuml -b branch-0.6
git clone --recurse-submodules https://github.com/rapidsai/dask-cuml

git clone --recurse-submodules https://github.com/rapidsai/cugraph -b branch-0.6

git clone --recurse-submodules https://github.com/rapidsai/dask-cuda
git clone --recurse-submodules https://github.com/rapidsai/dask-cudf

git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost

git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop rapidsai-xgboost
cd rapidsai-xgboost && git submodule update --init --recursive -- dmlc-core

#git clone --recursive https://github.com/dmlc/xgboost.git
#git clone --recurse-submodules https://github.com/dmlc/xgboost
#cd xgboost && git submodule update --init --recursive -- dmlc-core

cd ..
docker build -t rapids-strings .
