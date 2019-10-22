if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

# cleanup previous clones
rm -rf rmm
rm -rf cu*
rm -rf dask-*
rm -rf xgboost

BRANCH=branch-0.11

git clone --recurse-submodules https://github.com/rapidsai/rmm -b ${BRANCH}

# cuStrings merged into cuDF: https://github.com/rapidsai/cudf/pull/2394

git clone https://github.com/rapidsai/cudf -b $BRANCH
cd cudf
git submodule update --init --recursive --remote
# useful for checking out a specific PR
#git fetch origin pull/2629/head:remote
#git checkout remote
cd ..

# cuML is cloned by build.sh
git clone --recurse-submodules https://github.com/rapidsai/cuml.git -b $BRANCH

git clone https://github.com/rapidsai/cugraph -b $BRANCH
cd cugraph
git submodule update --init --recursive --remote
cd ..

git clone --recurse-submodules https://github.com/rapidsai/dask-cuda

# should now use xgboost.dask
git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost -b dask-cudf

# should now clone/build from dmlc/xgboost master
#git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop xgboost
#cd xgboost && git submodule update --init --recursive --remote -- dmlc-core

git clone --recursive https://github.com/dmlc/xgboost.git
cd xgboost && git submodule update --init --recursive -- dmlc-core
cd ..

git clone --recurse-submodules https://github.com/rapidsai/cuspatial -b ${BRANCH}

git clone --recurse-submodules https://github.com/rapidsai/cuDataShader cudatashader

cd ..
