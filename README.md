Flutter Docker image
=================

[![Release](https://img.shields.io/github/v/release/instrumentisto/flutter-docker-image "Release")](https://github.com/instrumentisto/flutter-docker-image/releases)
[![CI](https://github.com/instrumentisto/flutter-docker-image/workflows/CI/badge.svg?branch=master "CI")](https://github.com/instrumentisto/flutter-docker-image/actions?query=workflow%3ACI+branch%3Amaster)
[![Docker Hub](https://img.shields.io/docker/pulls/instrumentisto/flutter?label=Docker%20Hub%20pulls "Docker Hub pulls")](https://hub.docker.com/r/instrumentisto/flutter)

[Docker Hub](https://hub.docker.com/r/instrumentisto/flutter)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/flutter)
| [Quay.io](https://quay.io/repository/instrumentisto/flutter)

[Changelog](https://github.com/instrumentisto/flutter-docker-image/blob/master/CHANGELOG.md)




## Supported tags and respective `Dockerfile` links

- [`2.5.3`, `2.5`, `2`, `latest`][201]




## What is Flutter Docker image?

Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.
  
This image contains all the neccessary toolkit to build Flutter desktop application on Linux.

> [flutter.dev](https://flutter.dev)

![Flutter Logo](https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png)




## How to use this image

Just use any `flutter`-releated command with `docker run instrumentisto/flutter`.

```bash
docker run --rm -it instrumentisto/flutter flutter doctor
```




## Image versions

This image is based on the [Flutter framework][1], available in [the cirrusci image][2].


### `X`

Latest tag of `X` Flutter's major version.


### `X.Y`

Latest tag of a concrete `X.Y` version of Flutter.




## License

Nmap is licensed under [GPLv2 license][92].

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The [sources][90] for producing `instrumentisto/flutter` Docker images are licensed under [Blue Oak Model License 1.0.0][91].




## Issues

We can't notice comments in the [DockerHub] (or other container registries) so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][80].





[DockerHub]: https://hub.docker.com

[1]: https://flutter.dev
[2]: https://hub.docker.com/r/cirrusci/flutter

[80]: https://github.com/instrumentisto/flutter-docker-image/issues
[90]: https://github.com/instrumentisto/flutter-docker-image
[91]: https://github.com/instrumentisto/flutter-docker-image/blob/master/LICENSE.md
[92]: https://nmap.org/data/COPYING

[201]: https://github.com/instrumentisto/flutter-docker-image/blob/master/Dockerfile
