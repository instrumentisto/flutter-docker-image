# https://hub.docker.com/r/cirrusci/flutter/
ARG flutter_ver=2.5.3
FROM cirrusci/flutter:${flutter_ver}

LABEL org.opencontainers.image.source="\
    https://github.com/instrumentisto/flutter-docker-image"


# Install dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
            cmake ninja-build clang build-essential \
            pkg-config libgtk-3-dev liblzma-dev lcov

# Enable Linux support
RUN flutter config --enable-linux-desktop
