#!/bin/bash
set -e

rm -rf $REPOS_DIR
mkdir -p $REPOS_DIR

function gh_clone {
  mkdir -p $REPOS_DIR/$1
  git clone https://github.com/$1.git $REPOS_DIR/$1
  pushd $REPOS_DIR/$1
  git checkout ${2:-master}
  popd
}

# gh_clone crystal-lang/crystal

gh_clone crystal-lang/crystal-db
gh_clone crystal-lang/crystal-mysql
gh_clone crystal-lang/crystal-sqlite3
gh_clone will/crystal-pg

gh_clone kemalcr/kemal
gh_clone luckyframework/lucky
gh_clone amberframework/amber
