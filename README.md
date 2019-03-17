This repo uses setup.sh to clone and setup local copies of RAPIDS repositories.

A Dockerfile adds relevant folders from each repo into the container image.

The Dockerfile uses [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) to make development/testing at multiple levels of the stack (CUDA/C++, Python bindings, docstrings, workflow testing, etc) easier.

It has several targets:

1. [RAPIDS-BASE](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L4) - base environment with apt & conda packages necessary to build future stages
2. [CUSTRINGS](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L51) - built from rapids-base, includes custrings/nvstrings built from source
3. [CUDF](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L68) - built from custrings, includes cudf built from source against the source build of custrings
4. [XGBOOST](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L96) - built from cudf, includes xgboost built from source against the source build of cudf
5. [CUML](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L115) - built from cudf, includes cuml built from source against the source build of cudf
6. [CUGRAPH](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L138) - built from cudf, includes cugraph built from source against the source build of cudf
7. [RAPIDS](https://github.com/randerzander/docker-rapids/blob/multistage-builds/Dockerfile#L152). - built from cudf, includes all packages & Jupyterlab, useful for workflow testing

The various stages are organized with Python development in-mind. It assumes that underlying cpp code changes less often than Python bindings, and thus builds c++ libraries first, then installs Python bindings.

This lets devs change Python bindings & docstrings and rebuild container images often without needing to rebuild underlying c++ libraries.

Usage:
```bash
# clones relevant repos
sh setup.sh

# builds all RAPIDS projects, takes 20ish minutes
docker build --target RAPIDS --tag rapids .

# starts jupyterlab with dask web dashboard exposed
# adds localhost's "/raid" folder to "/data" in the container
# adds localhost's "/home/dev/projects/notebook-dev" to "/notebooks" in the container
# any changes to /data or /notebooks in the container are saved on the host as well

docker run -p 8888:8888 -p 8787:8787 -p 8000:8000 \
    -v /raid:/data -v /home/dev/projects/notebook-dev:/notebooks \
    -it rapids
```

*Note*: RAPIDS projects take a long time to build. If cudf's c++ code changes, everything that depends on it needs to be rebuilt (XGBoost, cuML, and cuGraph).

You can build for the "furthest down" target needed.

For example, if you're only testing cudf, you can build only the CUDF target:
```bash
docker build --target CUDF --tag cudf .
```
