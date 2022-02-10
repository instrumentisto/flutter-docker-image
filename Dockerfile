# https://hub.docker.com/r/cirrusci/android-sdk
# https://github.com/cirruslabs/docker-images-android/blob/master/sdk/30/Dockerfile
ARG android_sdk_ver=30
FROM cirrusci/android-sdk:${android_sdk_ver}

ARG flutter_ver=2.10.1
ARG build_rev=0

LABEL org.opencontainers.image.source="\
    https://github.com/instrumentisto/flutter-docker-image"


# Install Flutter
ENV FLUTTER_HOME=/usr/local/flutter \
    FLUTTER_VERSION=${flutter_ver} \
    PATH=$PATH:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends --no-install-suggests \
            ca-certificates \
 && update-ca-certificates \
    \
 # Install dependencies for Linux toolchain
 && apt-get install -y --no-install-recommends --no-install-suggests \
            build-essential \
            clang cmake \
            lcov \
            libgtk-3-dev liblzma-dev \
            ninja-build \
            pkg-config \
    \
 # Install Flutter itself
 && curl -fL -o /tmp/flutter.tar.xz \
         https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${flutter_ver}-stable.tar.xz \
 && tar -xf /tmp/flutter.tar.xz -C /usr/local/ \
 && flutter config --enable-android \
                   --enable-linux-desktop \
                   --enable-web \
                   --no-enable-ios \
 && flutter precache --universal --linux --web --no-ios \
 && (yes | flutter doctor --android-licenses) \
    \
 && rm -rf /var/lib/apt/lists/* \
           /tmp/*
