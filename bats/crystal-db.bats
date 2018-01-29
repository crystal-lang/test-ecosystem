#!/usr/bin/env bats

@test "db specs" {
  cd $REPOS_DIR
  cd crystal-db
  crystal deps
  crystal spec
}

@test "sqlite3 specs" {
  cd $REPOS_DIR
  cd crystal-sqlite3
  crystal deps
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-db ./lib/db
  crystal spec
}
