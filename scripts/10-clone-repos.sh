#!/bin/bash
set -e

rm -rf $REPOS_DIR
mkdir -p $REPOS_DIR

# gh_clone org/repo : will checkout master at $REPOS_DIR/org/repo
# gh_clone org/repo branch : will checkout branch at $REPOS_DIR/org/repo
# gh_clone org/repo branch fork: will checkout branch of github:fork at $REPOS_DIR/org/repo
function gh_clone {
  local repo_wk=${REPOS_DIR}/$1
  local upstream_gh_repo=${3:-$1}
  local shards_cache_dir=${SHARDS_CACHE_PATH}/github.com/$upstream_gh_repo.git

  # Reuse shards global cache.
  # It assumes that cache is clear before the whole testing per release
  if [ ! -d $shards_cache_dir ]; then
    git clone --mirror --quiet https://github.com/$upstream_gh_repo.git $shards_cache_dir
  fi

  # checkout from shards cache
  mkdir -p $repo_wk
  git clone --branch ${2:-master} $shards_cache_dir $repo_wk
}

gh_clone crystal-lang/crystal
gh_clone crystal-lang/shards

gh_clone crystal-lang/crystal_lib

gh_clone crystal-lang/crystal-db
gh_clone crystal-lang/crystal-mysql
gh_clone crystal-lang/crystal-sqlite3
gh_clone will/crystal-pg

gh_clone manastech/webmock.cr crystal/1.0.0

gh_clone veelenga/ameba

gh_clone kemalcr/kemal refactor/run_spec_exit_status bcardiff/kemal
gh_clone luckyframework/lucky v0.23.0
gh_clone luckyframework/lucky_cli v0.23.0
gh_clone luckyframework/avram v0.16.0
gh_clone amberframework/amber
gh_clone amberframework/granite

# Copy samples directory to $REPOS_DIR/samples
DIR=$(dirname $0)
cp -r ${DIR}/../samples ${REPOS_DIR}/samples
