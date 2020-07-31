#!/usr/bin/env bats

@test "lucky specs" {
  pushd $REPOS_DIR/luckyframework/lucky
  shards

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

  shards build

  popd
  popd
}
