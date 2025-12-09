#!/bin/sh
set +x

# docker build --progress=plain -t dotdotdot:latest .
docker build -t dotdotdot:latest .
docker run \
	-v "$(pwd)/dotfiles/zsh/.zshrc:/home/ubuntu/.zshrc" \
	-v "$(pwd)/dotfiles/zsh/.gauravmm.omp.yaml:/home/ubuntu/.gauravmm.omp.yaml" \
	-it --rm dotdotdot:latest
