wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

git clone https://github.com/rapidsai/custrings -b branch-0.3
cd custrings
git submodule update --init --recursive
cd ..

git clone https://github.com/rapidsai/cudf -b branch-0.6
cd cudf
git submodule update --init --recursive
cd ..

git clone https://github.com/rapidsai/cuml -b branch-0.6
cd cuml
git submodule update --init --recursive
cd ..

git clone https://github.com/rapidsai/cugraph -b branch-0.6
cd cugraph
git submodule update --init --recursive
cd ..

git clone --recurse-submodules https://github.com/rapidsai/dask-cudf
cd dask-cudf
# remove requirement for cudf 0.6
sed -i 1d requirements.txt
cd ..

git clone --recurse-submodules https://github.com/rapidsai/dask-cuml
git clone --recurse-submodules https://github.com/rapidsai/dask-cuda
git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost


git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop rapidsai-xgboost
cd rapidsai-xgboost && git submodule update --init --recursive -- dmlc-core

#git clone --recursive https://github.com/dmlc/xgboost.git
#git clone  https://github.com/dmlc/xgboost
#cd xgboost && git submodule update --init --recursive -- dmlc-core

cd ..
docker build -t rapids .
