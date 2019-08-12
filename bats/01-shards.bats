#!/usr/bin/env bats

@test "shards specs" {
  pushd $REPOS_DIR/crystal-lang/shards

  shards
  make
  make test

  popd
}
