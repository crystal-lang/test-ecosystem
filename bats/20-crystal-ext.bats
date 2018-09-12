#!/usr/bin/env bats

@test "webmock.cr specs" {
  pushd $REPOS_DIR/manastech/webmock.cr
  shards
  crystal spec
  popd
}

@test "crystal_lib specs" {
  pushd $REPOS_DIR/crystal-lang/crystal_lib
  crystal spec
  popd
}
