#!/usr/bin/env bats

override_shard () {
  rm -rf ./.crystal/shards/$1 && ln -s $2 ./.crystal/shards/$1
}

@test "db specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-db
  shards
  crystal spec
  popd
}

@test "sqlite3 specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-sqlite3

  shards
  override_shard db $REPOS_DIR/crystal-lang/crystal-db

  crystal spec
  popd
}

@test "mysql specs" {
  pushd $REPOS_DIR/crystal-lang/crystal-mysql

  shards
  override_shard db $REPOS_DIR/crystal-lang/crystal-db

  DATABASE_HOST="$MYSQL_HOST" crystal spec
  popd
}

@test "pg specs" {
  pushd $REPOS_DIR/will/crystal-pg

  shards
  override_shard db $REPOS_DIR/crystal-lang/crystal-db

  DATABASE_URL="postgres://postgres@$POSTGRES_HOST/crystal" crystal spec
  popd
}
