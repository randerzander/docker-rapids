if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

# cleanup previous clones
rm -rf rmm
rm -rf cu*
rm -rf dask-*
rm -rf xgboost
rm -rf ucx
rm -rf ucx-py
rm -rf repos

BRANCH=branch-0.13
UCX_BRANCH=v1.7.x

mkdir -p repos
git clone --recurse-submodules https://github.com/rapidsai/rmm -b ${BRANCH} repos/rmm

git clone https://github.com/rapidsai/cudf -b $BRANCH repos/cudf
cd repos/cudf
git submodule update --init --recursive --remote
# useful for checking out a specific PR
#git fetch origin pull/4016/head:remote
#git checkout remote
cd ../..

# cuML is cloned by build.sh
git clone --recurse-submodules https://github.com/rapidsai/cuml.git -b $BRANCH repos/cuml

git clone https://github.com/rapidsai/cugraph -b $BRANCH repos/cugraph
cd repos/cugraph
git submodule update --init --recursive --remote
cd ../..

git clone --recurse-submodules https://github.com/rapidsai/dask-cuda -b ${BRANCH} repos/dask-cuda

# should now use xgboost.dask
git clone --recurse-submodules https://github.com/rapidsai/dask-xgboost -b dask-cudf repos/dask-xgboost

# should now clone/build from dmlc/xgboost master
#git clone --recursive https://github.com/rapidsai/xgboost -b cudf-interop xgboost
#cd xgboost && git submodule update --init --recursive --remote -- dmlc-core

git clone --recursive https://github.com/dmlc/xgboost.git repos/xgboost
cd repos/xgboost && git submodule update --init --recursive -- dmlc-core
cd ../..

git clone --recurse-submodules https://github.com/rapidsai/cuspatial -b ${BRANCH} repos/cuspatial

git clone --recurse-submodules https://github.com/rapidsai/cuDataShader repos/cudatashader

# ucx
git clone https://github.com/openucx/ucx -b ${UCX_BRANCH} repos/ucx
git clone https://github.com/rapidsai/ucx-py -b ${BRANCH} repos/ucx-py
