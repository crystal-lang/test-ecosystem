#!/usr/bin/env bats

@test "shards specs" {
  pushd $REPOS_DIR/crystal-lang/shards

  local OLD_SHARDS_OPTS=$SHARDS_OPTS
  make
  unset SHARDS_OPTS
  make test
  export SHARDS_OPTS=$OLD_SHARDS_OPTS

  popd
}
