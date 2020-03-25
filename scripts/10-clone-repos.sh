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
  git clone $shards_cache_dir $repo_wk
  pushd $repo_wk
  git checkout ${2:-master}
  popd
}

gh_clone crystal-lang/crystal
gh_clone crystal-lang/shards crystal/v0.30.0 bcardiff/shards

gh_clone crystal-lang/crystal_lib

gh_clone crystal-lang/crystal-db
gh_clone crystal-lang/crystal-mysql
gh_clone crystal-lang/crystal-sqlite3
gh_clone will/crystal-pg

gh_clone manastech/webmock.cr

gh_clone veelenga/ameba

gh_clone kemalcr/kemal
gh_clone luckyframework/lucky
gh_clone luckyframework/lucky_cli
gh_clone luckyframework/avram
gh_clone amberframework/amber
gh_clone amberframework/granite

# Copy samples directory to $REPOS_DIR/samples
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cp -r ${DIR}/../samples ${REPOS_DIR}/samples
