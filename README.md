This repo uses setup.sh to clone and setup local copies of RAPIDS repositories.

A Dockerfile mounts the relevant source folders from each repo into the container at runtime as a volume.

CMD is setup to run [build.sh](build.sh) and launch Jupyter.

Usage:
```bash
# clones relevant repos
sh setup.sh

# sets up the build environment for all RAPIDS projects
docker build -t branch-0.10 .

# starts the container with appropriate volumes mounted, builds, and starts Jupyter
docker run -p 8888:8888 -p 8787:8787 -p 8000:8000 \
    -v ${PWD}:/rapids \
    -v /data:/data \
    -v /home/dev/projects/dev-notebooks:/notebooks \
    -it branch-0.10

# above run command is provided as a bash script: sudo sh run.sh
```

RAPIDS projects take time to build. If cudf's c++ code changes, everything that depends on it needs to be rebuilt (XGBoost, cuML, and cuGraph).

To speed things up, you can easily comment out build/install commands for packages you don't care about testing in [build.sh](build.sh).
