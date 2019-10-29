This branch creates a RAPIDS dev container based on current versions of nightly conda packages.

Usage:
```bash
# start the container, mounting local data and notebook dev directories as defined in run.sh
docker build -t nightly .
sudo sh run.sh
```
