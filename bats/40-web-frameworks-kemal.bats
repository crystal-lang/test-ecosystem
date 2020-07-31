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
