#!/usr/bin/env bats

# These tests cover libraries for testing for Crystal projects.
# They should require no special dependencies.

function setup() {
  load helper/common.bash
}

@test "ysbaddaden/minitest.cr" {
  shard_checkout https://github.com/ysbaddaden/minitest.cr

  crystal_spec
}

@test "arctic-fox/spectator" {
  skip "Does not build"
  shard_checkout https://gitlab.com/arctic-fox/spectator

  crystal_spec
}

@test "crystal-community/timecop.cr" {
  skiponwindows "Timeout"
  shard_checkout https://github.com/crystal-community/timecop.cr

  crystal_spec
}

@test "manastech/webmock.cr" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/manastech/webmock.cr

  crystal_spec
}
