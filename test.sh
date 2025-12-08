#!/bin/sh
set +x

# docker build --progress=plain -t dotdotdot:latest .
docker build -t dotdotdot:latest .
docker run -it --rm dotdotdot:latest
