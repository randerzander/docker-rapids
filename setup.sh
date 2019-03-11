git clone --recurse-submodules https://github.com/rapidsai/custrings
git clone --recurse-submodules https://github.com/rapidsai/cudf

cd cudf
git remote add kkraus14 https://github.com/kkraus14/cudf
git fetch kkraus14
git checkout kkraus14/fea-ext-string-support
cd ..

git clone --recurse-submodules https://github.com/rapidsai/cugraph

git clone --recurse-submodules https://github.com/rapidsai/dask-cuda
git clone --recurse-submodules https://github.com/rapidsai/dask-cudf

git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost

git clone --recursive https://github.com/dmlc/xgboost.git
git clone --recurse-submodules https://github.com/dmlc/xgboost
cd xgboost && git submodule update --init --recursive -- dmlc-core

cd ..
docker build -t rapids-strings .
