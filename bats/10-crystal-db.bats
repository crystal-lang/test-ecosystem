#!/usr/bin/env bats

@test "db specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-db
  shards
  crystal spec
  popd
}

@test "sqlite3 specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-sqlite3

  shards

  crystal spec
  popd
}

@test "mysql specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-mysql

  shards

  DATABASE_HOST="$MYSQL_HOST" crystal spec
  popd
}

@test "pg specs" {
  pushd $REPOS_DIR/will/crystal-pg

  shards

  DATABASE_URL="postgres://postgres@$POSTGRES_HOST/crystal" crystal spec
  popd
}
