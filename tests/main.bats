#!/usr/bin/env bats


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


@test "flutter linux support is enabled" {
  run docker run --rm --entrypoint sh $IMAGE -c \
    'flutter doctor'
  [[ "$output" == *"[✓] Linux"* ]]
}

