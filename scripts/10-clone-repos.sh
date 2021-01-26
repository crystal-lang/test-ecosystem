#!/bin/bash
set -e

rm -rf $REPOS_DIR
mkdir -p $REPOS_DIR

echo "dependencies:" > $REPOS_DIR/shard.override.yml

# override_shard name fork [branch_or_vTag=master]
function override_shard () {
  local branch=${3:-master}

  echo "  $1:" >> $REPOS_DIR/shard.override.yml
  echo "    github: $2" >> $REPOS_DIR/shard.override.yml

  case $branch in
    v*)
    echo "    version: ${branch:1}" >> $REPOS_DIR/shard.override.yml
    ;;
    *)
    echo "    branch: $branch" >> $REPOS_DIR/shard.override.yml
    ;;
  esac
}

# gh_clone org/repo : will checkout master at $REPOS_DIR/org/repo
# gh_clone org/repo branch_or_vTag : will checkout branch at $REPOS_DIR/org/repo
# gh_clone org/repo branch_or_vTag fork: will checkout branch of github:fork at $REPOS_DIR/org/repo
function gh_clone {
  local repo_wk=${REPOS_DIR}/$1
  local upstream_gh_repo=${3:-$1}
  local shards_cache_dir=${SHARDS_CACHE_PATH}/github.com/$upstream_gh_repo.git
  local shard_branch=${2:-master}

  # Reuse shards global cache.
  # It assumes that cache is clear before the whole testing per release
  if [ ! -d $shards_cache_dir ]; then
    git clone --mirror --quiet https://github.com/$upstream_gh_repo.git $shards_cache_dir
  fi

  # checkout from shards cache
  mkdir -p $repo_wk
  git clone --branch $shard_branch $shards_cache_dir $repo_wk

  if [[ -f "$repo_wk/shard.yml" ]]; then
    local shard_name=$(crystal eval "require \"yaml\"; puts YAML.parse(File.read(\"$repo_wk/shard.yml\"))[\"name\"]")
    override_shard $shard_name $upstream_gh_repo $shard_branch
  fi
}

gh_clone crystal-lang/crystal
gh_clone crystal-lang/shards

gh_clone crystal-lang/crystal_lib crystal/0.36.0

gh_clone crystal-lang/crystal-db
gh_clone crystal-lang/crystal-mysql
gh_clone crystal-lang/crystal-sqlite3
gh_clone will/crystal-pg

gh_clone manastech/webmock.cr crystal/0.36.0

gh_clone crystal-ameba/ameba master

gh_clone kemalcr/kemal
gh_clone luckyframework/lucky
gh_clone luckyframework/lucky_cli
gh_clone luckyframework/avram
gh_clone amberframework/amber crystal/0.36.0 bcardiff/amber
gh_clone amberframework/granite crystal/0.36.0 bcardiff/granite
gh_clone TechMagister/liquid.cr

override_shard dexter luckyframework/dexter
override_shard exception_page bcardiff/exception_page fix-deprecation

cat $REPOS_DIR/shard.override.yml

# Copy samples directory to $REPOS_DIR/samples
DIR=$(dirname $0)
cp -r ${DIR}/../samples ${REPOS_DIR}/samples
