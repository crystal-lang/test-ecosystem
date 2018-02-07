#!/usr/bin/env bats

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

@test "amber build specs" {
  pushd $REPOS_DIR/amberframework/amber

  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db
  rm -rf ./lib/mysql && ln -s $REPOS_DIR/crystal-lang/crystal-mysql ./lib/mysql
  rm -rf ./lib/pg && ln -s $REPOS_DIR/will/crystal-pg ./lib/pg
  rm -rf ./lib/sqlite3 && ln -s $REPOS_DIR/crystal-lang/crystal-sqlite3 ./lib/sqlite3

  CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal build ./spec/build_spec.cr -D run_build_tests
  # CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal spec ./spec/build_spec.cr -D run_build_tests
  # CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal spec ./spec/amber -D run_build_tests

  popd
}
