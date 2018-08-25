#!/bin/sh
set -e

BASEDIR=$(dirname $0)
export SHARDS_CACHE_PATH=$BASEDIR/shards_cache
export REPOS_DIR=/tmp/repos
./scripts/10-clone-repos.sh
./scripts/20-run-bats.sh
