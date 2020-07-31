#!/bin/sh
set -e

BASEDIR=$(dirname $0)
export SHARDS_CACHE_PATH=$BASEDIR/shards_cache
export REPOS_DIR=/tmp/repos
export SHARDS_OVERRIDE=$REPOS_DIR/shard.override.yml
./scripts/10-clone-repos.sh
./scripts/20-run-bats.sh
