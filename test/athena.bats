#!/usr/bin/env bats

function setup_file() {
  load helper/common.bash

  git_checkout https://github.com/athena-framework/athena

  SHARDS_OVERRIDE=shard.dev.yml $SHARDS install
}

function setup() {
  load helper/common.bash
}

function test_component() {
  ./scripts/test.sh "$1"
}

@test "clock" {
  test_component "clock"
}
@test "console" {
  test_component "console"
}
@test "dependency_injection" {
  test_component "dependency_injection"
}
@test "dotenv" {
  test_component "dotenv"
}
@test "event_dispatcher" {
  test_component "event_dispatcher"
}
@test "framework" {
  test_component "framework"
}
@test "image_size" {
  test_component "image_size"
}
@test "mercure" {
  test_component "mercure"
}
@test "negotiation" {
  test_component "negotiation"
}
@test "routing" {
  test_component "routing"
}
@test "serializer" {
  test_component "serializer"
}
@test "spec" {
  test_component "spec"
}
@test "validator" {
  test_component "validator"
}
