This repo uses setup.sh to clone and setup local copies of RAPIDS repositories.

A Dockerfile is provided to add relevant folders from each repo into the container image.

The Dockerfile is organized with Python development in-mind. It assumes that underlying cpp code changes less often than Python bindings, and thus builds RAPIDS c++ libraries first, then installs Python bindings "later".

This lets devs change Python binding code and rebuild the container image frequently without needing to rebuild underlying c++ libraries.

Note: RAPIDS projects take a long time to build. If cudf's c++ code changes, everything that depends on it will be rebuilt (cuML, and cuGraph). If you're only testing cudf, I suggest commenting out the cuML and cuGraph build sections in the Dockerfile.

Usage:
```bash
# clone repos
sh setup.sh
# build Docker image (takes 10+ minutes for first build)
sudo sh build.sh

```bash
# start the container, mounting local data and notebook dev directories
sudo sh run.sh
```
