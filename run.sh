docker run  -p 8888:8888 -p 8787:8787 \
    -v /data:/data \
    -v /home/dev/projects/blogs/notebooks:/notebooks \
    -it rapids-strings
