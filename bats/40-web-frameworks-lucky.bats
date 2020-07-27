#!/usr/bin/env bats

override_shard () {
  rm -rf ./lib/$1 && ln -s $2 ./lib/$1
}

@test "lucky specs" {
  pushd $REPOS_DIR/luckyframework/lucky
  shards
  override_shard db $REPOS_DIR/crystal-lang/crystal-db
  override_shard pg $REPOS_DIR/will/crystal-pg
  override_shard lucky_cli $REPOS_DIR/luckyframework/lucky_cli

  crystal spec # due to #{(distance / 30).round.to_i} months ...

  popd
}

@test "lucky build cli" {
  pushd $REPOS_DIR/luckyframework/lucky_cli
  shards

  crystal build src/lucky.cr --release --no-debug

  popd
}

@test "lucky avram specs" {
  pushd $REPOS_DIR/luckyframework/avram
  shards
  override_shard db $REPOS_DIR/crystal-lang/crystal-db
  override_shard pg $REPOS_DIR/will/crystal-pg
  override_shard lucky_cli $REPOS_DIR/luckyframework/lucky_cli

  ln -s $REPOS_DIR/luckyframework/lucky_cli/lucky ./lucky
  export DATABASE_URL="postgres://postgres@$POSTGRES_HOST:5432/lucky_record_test"
  export BACKUP_DATABASE_URL="postgres://postgres@$POSTGRES_HOST:5432/TestDatabase"

  crystal run tasks.cr -- db.drop
  crystal run tasks.cr -- db.create
  crystal run tasks.cr -- db.migrate
  crystal run tasks.cr -- db.rollback_to 20180802180356
  crystal run tasks.cr -- db.rollback_all
  crystal run tasks.cr -- db.migrate.one
  crystal run tasks.cr -- db.migrate
  crystal run tasks.cr -- db.migrations.status
  crystal spec
  shards build

  unset DATABASE_URL
  unset BACKUP_DATABASE_URL

  popd
}

@test "lucky init" {
  pushd $REPOS_DIR/luckyframework

  ./lucky_cli/lucky init.custom lucky101 --api
  pushd lucky101

  shards
  rm -rf ./lib/lucky && ln -s $REPOS_DIR/luckyframework/lucky ./lib/lucky

  shards build

  popd
  popd
}
