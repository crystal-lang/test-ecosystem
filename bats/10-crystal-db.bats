#!/usr/bin/env bats

@test "db specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-db
  shards
  crystal spec $CRYSTAL_BUILD_OPTS
  popd
}

@test "sqlite3 specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-sqlite3

  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db

  crystal spec $CRYSTAL_BUILD_OPTS
  popd
}

@test "mysql specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-mysql

  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db

  DATABASE_HOST="$MYSQL_HOST" crystal spec $CRYSTAL_BUILD_OPTS
  popd
}

@test "pg specs" {
  pushd $REPOS_DIR/will/crystal-pg

  shards
  rm -rf ./lib/db && ln -s $REPOS_DIR/crystal-lang/crystal-db ./lib/db

  DATABASE_URL="postgres://postgres@$POSTGRES_HOST/crystal" crystal spec $CRYSTAL_BUILD_OPTS
  popd
}
