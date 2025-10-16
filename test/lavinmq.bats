#!/usr/bin/env bats

function setup_file() {
  load helper/common.bash

  git_checkout https://github.com/cloudamqp/lavinmq
}

function setup() {
  load helper/common.bash
}

@test "build lavinmq" {
  skiponwindows "not supported"
  make all CRYSTAL_FLAGS=
}

@test "test lavinmq" {
  skiponwindows "not supported"
  make test
}

# bats test_tags=format
@test "format lavinmq" {
  crystal_format
}
