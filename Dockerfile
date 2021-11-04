# https://hub.docker.com/r/cirrusci/flutter
# https://github.com/cirruslabs/docker-images-flutter/blob/master/sdk/Dockerfile
ARG flutter_ver=2.5.3
FROM cirrusci/flutter:${flutter_ver}

ARG build_rev=0

LABEL org.opencontainers.image.source="\
    https://github.com/instrumentisto/flutter-docker-image"


# Install dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
            build-essential \
            clang cmake \
            lcov \
            libgtk-3-dev liblzma-dev \
            ninja-build \
            pkg-config \
 # Cleanup unnecessary stuff
 && rm -rf /var/lib/apt/lists/*

# Enable Android and Linux support
RUN flutter config --enable-android \
 && flutter config --enable-linux-desktop
