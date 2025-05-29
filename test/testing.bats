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

# bats test_tags=format
@test "format ysbaddaden/minitest.cr" {
  check_crystal_format https://github.com/ysbaddaden/minitest.cr
}

@test "arctic-fox/spectator" {
  skip "Does not build"
  shard_checkout https://gitlab.com/arctic-fox/spectator

  crystal_spec
}

# bats test_tags=format
@test "format arctic-fox/spectator" {
  check_crystal_format https://gitlab.com/arctic-fox/spectator
}

@test "crystal-community/timecop.cr" {
  skiponwindows "Timeout"
  shard_checkout https://github.com/crystal-community/timecop.cr

  # https://github.com/crystal-community/timecop.cr/issues/12
  git apply <<-DIFF
--- i/spec/timecop_spec.cr
+++ w/spec/timecop_spec.cr
@@ -98,6 +98,7 @@ describe Timecop do

   context ".scale" do
     it "keeps time moving at an accelerated rate" do
+      pending! if {{ flag?(:darwin) }}
       time = Time.local(2008, 10, 10, 10, 10, 10)
       Timecop.scale(time, 4) do
         start = Time.local
DIFF

  crystal_spec
}

# bats test_tags=format
@test "format crystal-community/timecop.cr" {
  check_crystal_format https://github.com/crystal-community/timecop.cr
}

@test "manastech/webmock.cr" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/manastech/webmock.cr

  crystal_spec
}

# bats test_tags=format
@test "format manastech/webmock.cr" {
  check_crystal_format https://github.com/manastech/webmock.cr
}
