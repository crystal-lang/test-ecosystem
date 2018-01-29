#!/usr/bin/env bats

@test "db specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-db
  shards
  crystal spec
  popd
}

@test "sqlite3 specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-sqlite3

  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db

  crystal spec
  popd
}
