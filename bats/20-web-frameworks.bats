#!/usr/bin/env bats

@test "amber specs" {
  pushd $REPOS_DIR/amberframework/amber
  shards
  # rm -rf ./lib/have_files && ln -s $REPOS_DIR/have_files ./lib/have_files
  # rm -rf ./lib/cli && ln -s $REPOS_DIR/cli ./lib/cli
  # rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-db ./lib/db
  # rm -rf ./lib/mysql && ln -s $REPOS_DIR/crystal-mysql ./lib/mysql
  # rm -rf ./lib/pg && ln -s $REPOS_DIR/crystal-pg ./lib/pg
  # rm -rf ./lib/sqlite3 && ln -s $REPOS_DIR/crystal-sqlite3 ./lib/sqlite3
  # rm -rf ./lib/slang && ln -s $REPOS_DIR/slang ./lib/slang
  # rm -rf ./lib/teeplate && ln -s $REPOS_DIR/teeplate ./lib/teeplate
  # rm -rf ./lib/sentry && ln -s $REPOS_DIR/sentry ./lib/sentry
  crystal spec ./spec/build_spec.cr -D run_build_tests
  crystal spec ./spec/amber -D run_build_tests
  popd
}

@test "kemal specs" {
  pushd $REPOS_DIR/kemalcr/kemal
  shards

  crystal spec
  crystal spec --release --no-debug

  popd
}

@test "lucky specs" {
  pushd $REPOS_DIR/luckyframework/lucky
  shards

  crystal spec

  popd
}
