#!/bin/sh
set -e

export BASEDIR=${BASEDIR:-$(dirname $0)}
export SHARDS_CACHE_PATH=${SHARDS_CACHE_PATH:-$BASEDIR/shards_cache}
export REPOS_DIR=${REPOS_DIR:-/tmp/repos}
export SHARDS_OVERRIDE=${SHARDS_OVERRIDE:-$REPOS_DIR/shard.override.yml}
