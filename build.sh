set -eu

REPO_DIR=/rapids/repos

cd $REPO_DIR/rmm
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX}
make -j install
cd $REPO_DIR/rmm/python
python setup.py install

cd $REPO_DIR/cudf
bash $REPO_DIR/cudf/build.sh libnvstrings nvstrings
bash $REPO_DIR/cudf/build.sh libcudf cudf

cd $REPO_DIR/cudf/python/dask_cudf
python setup.py install

cd $REPO_DIR/dask-cuda
python setup.py install

cd $REPO_DIR/xgboost
mkdir -p $REPO_DIR/xgboost/build
cd $REPO_DIR/xgboost/build
cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
      -DUSE_CUDF=ON -DCMAKE_CXX11_ABI=ON \
      -DUSE_CUDA=ON -DUSE_NCCL=ON
make -j install
cd $REPO_DIR/xgboost/python-package
python setup.py bdist_wheel
python setup.py install

cd $REPO_DIR/dask-xgboost
#python setup.py install

# needs to be before cuml build
export CUDA_HOME=/usr/local/cuda
cd $REPO_DIR/ucx
./autogen.sh
mkdir -p build
cd build
../configure --prefix=$CONDA_PREFIX --enable-debug --with-cuda=$CUDA_HOME --enable-mt CPPFLAGS="-I//$CUDA_HOME/include"
make -j install

cd $REPO_DIR/ucx-py
python setup.py build_ext --inplace
python -m pip install -e .

cd $REPO_DIR/cuml
bash build.sh libcuml cuml

cd $REPO_DIR/cugraph
# broken after libcudf++ refactor
bash build.sh libcugraph cugraph

export CUDF_HOME=/rapids/cudf
export CUSPATIAL_HOME=/rapids/cuspatial
mkdir -p $REPO_DIR/cuspatial/cpp/build
cd $REPO_DIR/cuspatial/cpp/build
#cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX
# broken after libcudf++ refactor
#make install
cd $REPO_DIR/cuspatial/python/cuspatial
#python setup.py build_ext --inplace
#python setup.py install

cd $REPO_DIR/cudatashader
python setup.py install
