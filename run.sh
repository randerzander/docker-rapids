docker run -p 8888:8888 -p 8787:8787 -p 8000:8000 \
    --rm \
    --net=host \
    -w="/raid/randy" \
    -v ${PWD}:/rapids \
    -v /raid:/raid \
    -v /datasets:/datasets \
    -v /home/nfs/rgelhausen/projects:/projects \
    -v /home/nfs/rgelhausen/projects/dev-notebooks:/notebooks \
    -it branch-0.13
