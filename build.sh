set -eu

cd /rapids/rmm
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX}
make -j install
cd /rapids/rmm/python
python setup.py install

cd /rapids/cudf
bash /rapids/cudf/build.sh libnvstrings nvstrings
bash /rapids/cudf/build.sh libcudf cudf

cd /rapids/cudf/python/dask_cudf
python setup.py install

cd /rapids/dask-cuda
python setup.py install

cd /rapids/xgboost
mkdir -p /rapids/xgboost/build
cd /rapids/xgboost/build
cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
      -DUSE_CUDF=ON -DCMAKE_CXX11_ABI=ON \
      -DUSE_CUDA=ON -DUSE_NCCL=ON
make -j install
cd /rapids/xgboost/python-package
python setup.py bdist_wheel
python setup.py install

cd /rapids/dask-xgboost
python setup.py install

# needs to be before cuml build
export CUDA_HOME=/usr/local/cuda
cd /rapids/ucx
./autogen.sh
mkdir -p build
cd build
../configure --prefix=$CONDA_PREFIX --enable-debug --with-cuda=$CUDA_HOME --enable-mt CPPFLAGS="-I//$CUDA_HOME/include"
make -j install

cd /rapids/ucx-py
python setup.py build_ext --inplace
python -m pip install -e .

cd /rapids/cuml
bash build.sh libcuml cuml

cd /rapids/cugraph
# broken after libcudf++ refactor
#bash build.sh libcugraph cugraph

export CUDF_HOME=/rapids/cudf
export CUSPATIAL_HOME=/rapids/cuspatial
mkdir -p /rapids/cuspatial/cpp/build
cd /rapids/cuspatial/cpp/build
cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX
# broken after libcudf++ refactor
#make install
cd /rapids/cuspatial/python/cuspatial
#python setup.py build_ext --inplace
#python setup.py install

cd /rapids/cudatashader
python setup.py install
