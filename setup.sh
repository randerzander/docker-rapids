if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

# cleanup previous clones
rm -rf rmm
rm -rf cu*
rm -rf dask*
rm -rf xgboost

BRANCH=branch-0.9

git clone --recurse-submodules https://github.com/rapidsai/rmm -b ${BRANCH}

git clone https://github.com/rapidsai/custrings -b $BRANCH
cd custrings
git submodule update --init --recursive --remote
cd ..

git clone https://github.com/rapidsai/cudf -b $BRANCH
cd cudf
git submodule update --init --recursive --remote
# useful for checking out a specific PR
#git fetch origin pull/2018/head:groupby
#git checkout groupby
cd ..

git clone https://github.com/rapidsai/cuml -b $BRANCH
cd cuml
git submodule update --init --recursive --remote
cd ..

git clone https://github.com/rapidsai/cugraph -b $BRANCH
cd cugraph
git submodule update --init --recursive --remote
cd ..

git clone --recurse-submodules https://github.com/rapidsai/dask-cuml
git clone --recurse-submodules https://github.com/rapidsai/dask-cuda

git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost -b dask-cudf


git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop xgboost
cd xgboost && git submodule update --init --recursive --remote -- dmlc-core

#git clone --recursive https://github.com/dmlc/xgboost.git
#git clone  https://github.com/dmlc/xgboost
#cd xgboost && git submodule update --init --recursive -- dmlc-core

cd ..
