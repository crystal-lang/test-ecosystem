#!/usr/bin/env bats

@test "amber granite specs" {
  pushd $REPOS_DIR/amberframework/granite
  shards

  export PG_DATABASE_URL="postgres://postgres:@$POSTGRES_HOST:5432/postgres"
  export MYSQL_DATABASE_URL="mysql://root@$MYSQL_HOST:3306/test_granite"
  export SQLITE_DATABASE_URL="sqlite3:./test.db"

  export CURRENT_ADAPTER="sqlite"
  crystal spec

  export CURRENT_ADAPTER="mysql"
  crystal spec

  export CURRENT_ADAPTER="pg"
  crystal spec

  unset PG_DATABASE_URL
  unset MYSQL_DATABASE_URL
  unset SQLITE_DATABASE_URL
  unset CURRENT_ADAPTER

  popd
}

@test "amber specs (build)" {
  pushd $REPOS_DIR/amberframework/amber

  shards

  shards build
  ./bin/amber -v

  export CI="true"
  export AMBER_ENV="test"
  export REDIS_URL="redis://$REDIS_HOST:6379"
  export DATABASE_URL="postgres://postgres@$POSTGRES_HOST:5432/amber_test"

  # unable to run specs because spec/build_spec_[granite|crecto].cr:23/49
  # expect localhost database instead of DATABASE_URL
  crystal build ./spec/build_spec_granite.cr

  # Environment file not found for ./config/environments/production
  crystal build ./spec/amber/**.cr

  unset CI
  unset AMBER_ENV
  unset REDIS_URL
  unset DATABASE_URL

  popd
}

@test "amber init" {
  pushd $REPOS_DIR/amberframework

  ./amber/bin/amber new amber101
  pushd amber101
  shards

  shards build

  popd
  popd
}
