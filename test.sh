#!/bin/sh
set +x

# docker build --progress=plain -t dotdotdot:latest .
docker build -t dotdotdot:latest .
docker run \
	-v "$(pwd)/dotfiles/zsh/.zshrc:/home/ubuntu/.zshrc" \
	-v "$(pwd)/dotfiles/zsh/.gauravmm.omp.json:/home/ubuntu/.gauravmm.omp.json"
-it --rm dotdotdot:latest
