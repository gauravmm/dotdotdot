FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# See docs here for caching: https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md#example-cache-apt-packages
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates bc git zsh curl rsync wget ssh \
    && rm -rf /var/lib/apt/lists/*

USER ubuntu

COPY --chown=ubuntu:ubuntu . /home/ubuntu/.dotdotdot
WORKDIR /home/ubuntu/.dotdotdot

# RUN ["./dotdotdot", "-vg"]

ENTRYPOINT ["zsh", "-c", "~/.dotdotdot/dotdotdot"]