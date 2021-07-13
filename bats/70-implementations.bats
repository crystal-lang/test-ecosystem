#!/usr/bin/env bats

@test "crinja specs" {
  pushd $REPOS_DIR/straight-shoota/crinja
  make test
  popd
}

@test "mint specs" {
  pushd $REPOS_DIR/mint-lang/mint
  shards install
  make test
  popd
}
