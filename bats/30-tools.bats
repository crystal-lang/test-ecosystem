#!/usr/bin/env bats

@test "ameba specs" {
  pushd $REPOS_DIR/veelenga/ameba
  shards

  shards build $CRYSTAL_BUILD_OPTS
  crystal spec $CRYSTAL_BUILD_OPTS
  ./bin/ameba --all

  popd
}
