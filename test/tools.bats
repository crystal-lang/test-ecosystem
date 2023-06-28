#!/usr/bin/env bats

# These tests cover applications that are used as tools for Crystal projects.

function setup() {
  load helper/common.bash
}

@test "crystal-ameba/ameba" {
  skiponwindows "Timeout"
  shard_checkout https://github.com/crystal-ameba/ameba

  crystal_spec
}
