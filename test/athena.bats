#!/usr/bin/env bats

function setup_file() {
  load helper/common.bash

  export SHARDS_OVERRIDE=shard.dev.yml
  shard_checkout https://github.com/athena-framework/athena
}

function setup() {
  load helper/common.bash
}

function test_shard() {
  ./scripts/test.sh "$1" "${2:-all}" "${3:-component}"
}

@test "mercure_bundle" {
  test_shard "mercure" "all" "bundle"
}
@test "clock" {
  test_shard "clock"
}
@test "console" {
  test_shard "console"
}
@test "dependency_injection" {
  test_shard "dependency_injection"
}
@test "dotenv" {
  test_shard "dotenv"
}
@test "event_dispatcher" {
  test_shard "event_dispatcher"
}
@test "framework" {
  test_shard "framework"
}
@test "http" {
  test_shard "http"
}
@test "http_kernel" {
  test_shard "http_kernel"
}
@test "image_size" {
  test_shard "image_size"
}
@test "mercure" {
  test_shard "mercure"
}
@test "mime" {
  test_shard "mime"
}
@test "negotiation" {
  test_shard "negotiation"
}
@test "routing" {
  test_shard "routing"
}
@test "serializer" {
  test_shard "serializer"
}
@test "spec" {
  test_shard "spec"
}
@test "validator" {
  test_shard "validator"
}

# bats test_tags=format
@test "format athena-framework/athena" {
  check_crystal_format https://github.com/athena-framework/athena
}
