# https://github.com/cirruslabs/docker-images-android/pkgs/container/android-sdk
# https://github.com/cirruslabs/docker-images-android/blob/master/sdk/35/Dockerfile
# TODO: Switch back to `${android_sdk_ver}` image version once
#       cirruslabs/docker-images-android#79 is resolved:
#       https://github.com/cirruslabs/docker-images-android/issues/79
FROM ghcr.io/cirruslabs/android-sdk:tools

ARG android_sdk_ver=36
ARG flutter_ver=3.38.0
ARG build_rev=0


# Switch Android SDK to 36 version.
# TODO: Remove once cirruslabs/docker-images-android#79 is resolved:
#       https://github.com/cirruslabs/docker-images-android/issues/79
RUN yes | sdkmanager \
    "platforms;android-${android_sdk_ver}" \
    "build-tools;${android_sdk_ver}.0.0"


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
 && git config --global --add safe.directory /usr/local/flutter \
 && flutter config --enable-android \
                   --enable-linux-desktop \
                   --enable-web \
                   --no-enable-ios \
 && flutter precache --universal --linux --web --no-ios \
 && (yes | flutter doctor --android-licenses) \
 && flutter --version \
    \
 # Make Flutter tools available for non-root usage
 && chown -R 1000:1000 /usr/local/flutter/packages/flutter_tools/.dart_tool/ \
    \
 && rm -rf /var/lib/apt/lists/* \
           /tmp/*
