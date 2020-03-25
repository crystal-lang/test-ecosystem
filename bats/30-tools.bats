#!/usr/bin/env bats

@test "ameba specs" {
  pushd $REPOS_DIR/veelenga/ameba
  shards

  shards build
  crystal spec
  ./bin/ameba --all

  popd
}
