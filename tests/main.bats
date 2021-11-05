#!/usr/bin/env bats


@test "clang is installed" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'which clang'
  [ "$status" -eq 0 ]
}

@test "clang runs ok" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'clang --help'
  [ "$status" -eq 0 ]
}


@test "flutter is installed" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'which flutter'
  [ "$status" -eq 0 ]
}

@test "flutter runs ok" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter --help'
  [ "$status" -eq 0 ]
}

@test "flutter doctor runs ok" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter doctor'
  [ "$status" -eq 0 ]
}

@test "flutter has correct version" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    "flutter --version | grep 'Flutter ' | cut -d ' ' -f 2 | tr -d ' '"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  actual="$output"

  run sh -c "cat Dockerfile | grep 'ARG flutter_ver=' \
                            | cut -d '=' -f 2 \
                            | tr -d ' '"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  expected="$output"

  [ "$actual" == "$expected" ]
}


@test "Android toolchain is enabled" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter config | grep "enable-android: true"'
  [ "$status" -eq 0 ]
}

@test "Android toolchain is present" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter doctor | grep "Android toolchain"'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[✓] Android toolchain"* ]]
}


@test "Linux toolchain is enabled" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter config | grep "enable-linux-desktop: true"'
  [ "$status" -eq 0 ]
}

@test "Linux toolchain is present" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter doctor | grep "Linux toolchain"'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[✓] Linux toolchain"* ]]
}


@test "Web toolchain is enabled" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter config | grep "enable-web: true"'
  [ "$status" -eq 0 ]
}
