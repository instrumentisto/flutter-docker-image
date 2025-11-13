Flutter Docker image
====================

[![Release](https://img.shields.io/github/v/release/instrumentisto/flutter-docker-image "Release")](https://github.com/instrumentisto/flutter-docker-image/releases)
[![CI](https://github.com/instrumentisto/flutter-docker-image/actions/workflows/ci.yml/badge.svg?branch=main "CI")](https://github.com/instrumentisto/flutter-docker-image/actions?query=workflow%3ACI+branch%3Amain)
[![Docker Hub](https://img.shields.io/docker/pulls/instrumentisto/flutter?label=Docker%20Hub%20pulls "Docker Hub pulls")](https://hub.docker.com/r/instrumentisto/flutter)

[Docker Hub](https://hub.docker.com/r/instrumentisto/flutter)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/flutter)
| [Quay.io](https://quay.io/repository/instrumentisto/flutter)

[Changelog](https://github.com/instrumentisto/flutter-docker-image/blob/main/CHANGELOG.md)

Based on [`ghcr.io/cirruslabs/android-sdk` Docker image][2].




## Supported tags and respective `Dockerfile` links

- [`3.38.0-androidsdk35-r0`, `3.38.0`, `3.38`, `3`, `latest`][201]




## Supported toolchains

- `Android`
- `Linux`
- `Web`




## What is [Flutter]?

[Flutter] is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.
  
This image contains all the necessary toolkit fot building [Flutter] applications.

> [flutter.dev](https://flutter.dev)

![Flutter Logo](https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png)




## How to use this image

Mount your project directory and run the necessary `flutter` command:
```bash
docker run --rm -v /my/rust/project:/app -w /app instrumentisto/flutter \
    flutter doctor
```


### Non-`root` usage

If you cannot run this image as `root`, use the `1000` user instead, which owns `flutter_tools` inside the image:
```bash
docker run --rm --user 1000:1000 \
           -v /my/rust/project:/app -w /app instrumentisto/flutter \
    flutter doctor
```




## Image tags


### `<X>`

Latest tag of the latest major `X` [Flutter] version.


### `<X.Y>`

Latest tag of the latest minor `X.Y` [Flutter] version.


### `<X.Y.Z>`

Latest tag of the concrete `X.Y.Z` [Flutter] version.


### `<X.Y.Z>-androidsdk<A>-r<N>`

Concrete `N` image revision tag of the concrete `X.Y.Z` [Flutter] version with the concrete `A` API level version of [Android SDK].

Once built, it's never updated.




## License

[Flutter] is licensed under [BSD 3-Clause "New" or "Revised" license][92].

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The [sources][90] for producing `instrumentisto/flutter` Docker images are licensed under [Blue Oak Model License 1.0.0][91].




## Issues

We can't notice comments in the [DockerHub] (or other container registries) so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][80].




[Android SDK]: https://developer.android.com/studio
[DockerHub]: https://hub.docker.com
[Flutter]: https://flutter.dev

[2]: https://github.com/cirruslabs/docker-images-android/pkgs/container/android-sdk

[80]: https://github.com/instrumentisto/flutter-docker-image/issues
[90]: https://github.com/instrumentisto/flutter-docker-image
[91]: https://github.com/instrumentisto/flutter-docker-image/blob/main/LICENSE.md
[92]: https://github.com/flutter/flutter/blob/master/LICENSE

[201]: https://github.com/instrumentisto/flutter-docker-image/blob/main/Dockerfile
