#!/bin/bash
set -e

rm -rf $REPOS_DIR
mkdir -p $REPOS_DIR

# gh_clone org/repo : will checkout master at $REPOS_DIR/org/repo
# gh_clone org/repo branch : will checkout branch at $REPOS_DIR/org/repo
# gh_clone org/repo branch fork: will checkout branch of github:fork at $REPOS_DIR/org/repo
function gh_clone {
  local repo_wk=${REPOS_DIR}/$1
  mkdir -p $repo_wk
  git clone https://github.com/${3:-$1}.git $repo_wk
  pushd $repo_wk
  git checkout ${2:-master}
  popd
}

gh_clone crystal-lang/crystal

gh_clone crystal-lang/crystal-db
gh_clone crystal-lang/crystal-mysql
gh_clone crystal-lang/crystal-sqlite3
gh_clone will/crystal-pg

gh_clone kemalcr/kemal
gh_clone luckyframework/lucky
gh_clone luckyframework/lucky_cli
gh_clone luckyframework/lucky_record
gh_clone amberframework/amber
