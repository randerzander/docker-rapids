docker run  -p 8888:8888 -p 8787:8787 -p 8000:8000 \
    -v /datasets:/data \
    -v /home/nfs/rgelhausen/projects/dev-notebooks:/notebooks \
    -it branch-0.10
