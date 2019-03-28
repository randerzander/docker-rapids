if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

rm -rf cu*
rm -rf dask*
rm -rf xgboost

git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost -b dask-cudf

git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop
cd xgboost && git submodule update --init --recursive -- dmlc-core

cd ..
