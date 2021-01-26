#!/usr/bin/env bats

@test "ameba specs" {
  pushd $REPOS_DIR/crystal-ameba/ameba
  shards

  shards build
  crystal spec
  ./bin/ameba --all

  popd
}
