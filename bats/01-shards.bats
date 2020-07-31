#!/usr/bin/env bats

@test "shards specs" {
  pushd $REPOS_DIR/crystal-lang/shards

  local OLD_SHARDS_OPTS=$SHARDS_OPTS
  local OLD_SHARDS_OVERRIDE=$SHARDS_OVERRIDE
  make
  unset SHARDS_OPTS
  unset SHARDS_OVERRIDE
  make test
  export SHARDS_OPTS=$OLD_SHARDS_OPTS
  export SHARDS_OVERRIDE=$OLD_SHARDS_OVERRIDE

  popd
}
