#!/usr/bin/env bats

@test "amber specs" {
  cd $REPOS_DIR
  cd amber
  crystal deps
  rm -rf ./lib/have_files && ln -s $REPOS_DIR/have_files ./lib/have_files
  rm -rf ./lib/cli && ln -s $REPOS_DIR/cli ./lib/cli
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-db ./lib/db
  rm -rf ./lib/mysql && ln -s $REPOS_DIR/crystal-mysql ./lib/mysql
  rm -rf ./lib/pg && ln -s $REPOS_DIR/crystal-pg ./lib/pg
  rm -rf ./lib/sqlite3 && ln -s $REPOS_DIR/crystal-sqlite3 ./lib/sqlite3
  rm -rf ./lib/slang && ln -s $REPOS_DIR/slang ./lib/slang
  rm -rf ./lib/teeplate && ln -s $REPOS_DIR/teeplate ./lib/teeplate
  rm -rf ./lib/sentry && ln -s $REPOS_DIR/sentry ./lib/sentry
  crystal spec -D run_build_tests
}

@test "kemal specs" {
  cd $REPOS_DIR
  cd kemal
  crystal deps
  crystal spec
  crystal spec --release --no-debug
}

@test "lucky specs" {
  cd $REPOS_DIR
  cd lucky

  crystal deps
  rm -rf ./lib/have_files && ln -s $REPOS_DIR/have_files ./lib/have_files
  rm -rf ./lib/teeplate && ln -s $REPOS_DIR/teeplate ./lib/teeplate
  rm -rf ./lib/lucky_cli && ln -s $REPOS_DIR/lucky_cli ./lib/lucky_cli

  rm ./spec/lucky/expose_spec.cr

  crystal spec
}
