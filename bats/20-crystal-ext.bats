#!/usr/bin/env bats

@test "webmock.cr specs" {
  pushd $REPOS_DIR/manastech/webmock.cr
  shards
  crystal spec
  popd
}

# TODO: crystal_lib