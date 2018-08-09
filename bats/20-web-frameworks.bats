#!/usr/bin/env bats

@test "kemal specs" {
  pushd $REPOS_DIR/kemalcr/kemal
  shards

  crystal spec
  crystal spec --release --no-debug

  popd
}

@test "kemal init" {
  pushd $REPOS_DIR/kemalcr

  crystal init app kemal101
  pushd kemal101

  mkdir ./lib

  echo "" >> ./shard.yml
  echo "dependencies:" >> ./shard.yml
  echo "  kemal:" >> ./shard.yml
  echo "    path: $REPOS_DIR/kemalcr/kemal" >> ./shard.yml
  echo "" >> ./shard.yml

  echo 'require "kemal";get "/" { "Hello World!"};Kemal.run' > ./src/kemal101.cr
  shards
  crystal build ./src/kemal101.cr # -D without_openssl

  popd
  popd
}

@test "lucky specs" {
  pushd $REPOS_DIR/luckyframework/lucky
  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db
  rm -rf ./lib/pg && ln -s $REPOS_DIR/will/crystal-pg ./lib/pg
  rm -rf ./lib/lucky_cli && ln -s $REPOS_DIR/luckyframework/lucky_cli ./lib/lucky_cli

  crystal spec

  popd
}

@test "lucky build cli" {
  pushd $REPOS_DIR/luckyframework/lucky_cli
  shards

  crystal build src/lucky.cr --release --no-debug

  popd
}

@test "lucky init" {
  pushd $REPOS_DIR/luckyframework

  ./lucky_cli/lucky init lucky101
  pushd lucky101

  shards
  rm -rf ./lib/lucky && ln -s $REPOS_DIR/luckyframework/lucky ./lib/lucky

  shards build

  popd
  popd
}

@test "amber build specs and build cli" {
  pushd $REPOS_DIR/amberframework/amber

  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db
  rm -rf ./lib/mysql && ln -s $REPOS_DIR/crystal-lang/crystal-mysql ./lib/mysql
  rm -rf ./lib/pg && ln -s $REPOS_DIR/will/crystal-pg ./lib/pg
  rm -rf ./lib/sqlite3 && ln -s $REPOS_DIR/crystal-lang/crystal-sqlite3 ./lib/sqlite3

  shards build
  ./bin/amber -v

  CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal build ./spec/build_spec_granite.cr -D run_build_tests
  CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal build ./spec/build_spec_crecto.cr -D run_build_tests
  # CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal spec ./spec/build_spec.cr -D run_build_tests
  # CI="true" AMBER_ENV="test" REDIS_URL="redis://$REDIS_HOST:6379" crystal spec ./spec/amber -D run_build_tests

  popd
}

@test "amber init" {
  pushd $REPOS_DIR/amberframework

  ./amber/bin/amber new amber101
  pushd amber101
  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db
  rm -rf ./lib/mysql && ln -s $REPOS_DIR/crystal-lang/crystal-mysql ./lib/mysql
  rm -rf ./lib/pg && ln -s $REPOS_DIR/will/crystal-pg ./lib/pg
  rm -rf ./lib/sqlite3 && ln -s $REPOS_DIR/crystal-lang/crystal-sqlite3 ./lib/sqlite3
  rm -rf ./lib/amber && ln -s $REPOS_DIR/amberframework/amber ./lib/amber

  shards build

  popd
  popd
}