#!/usr/bin/env bats

# These tests cover some of the most popular Crystal libraries (shards),
# identified via dependent counts on shardbox.org
# They should require no special dependencies except some basic libraries
# such as openssl.

function setup() {
  load 'helper/common.bash'
}

@test "Sija/backtracer.cr" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/Sija/backtracer.cr

  crystal_spec
}

# bats test_tags=format
@test "format Sija/backtracer.cr" {
  check_crystal_format https://github.com/Sija/backtracer.cr
}

# bats test_tags=openssl
@test "crystal-loot/exception_page" {
  skip "Specs are failing (https://github.com/crystal-loot/exception_page/issues/39)"
  skiponwindows "Does not build"
  shard_checkout https://github.com/crystal-loot/exception_page

  crystal_spec
}

# bats test_tags=format
@test "format crystal-loot/exception_page" {
  check_crystal_format https://github.com/crystal-loot/exception_page
}

@test "luislavena/radix" {
  shard_checkout https://github.com/luislavena/radix

  crystal_spec
}

# bats test_tags=format
@test "format luislavena/radix" {
  check_crystal_format https://github.com/luislavena/radix
}

@test "ysbaddaden/pool" {
  shard_checkout https://github.com/ysbaddaden/pool

  crystal_spec
}

@test "luckyframework/habitat" {
  shard_checkout https://github.com/luckyframework/habitat

  crystal_spec
}

# bats test_tags=format
@test "format luckyframework/habitat" {
  check_crystal_format https://github.com/luckyframework/habitat
}

@test "luckyframework/wordsmith" {
  shard_checkout https://github.com/luckyframework/wordsmith

  crystal_spec
}

# bats test_tags=format
@test "format luckyframework/wordsmith" {
  check_crystal_format https://github.com/luckyframework/wordsmith
}

@test "crystal-community/future.cr" {
  shard_checkout https://github.com/crystal-community/future.cr

  crystal_spec
}

# bats test_tags=format
@test "format crystal-community/future.cr" {
  check_crystal_format https://github.com/crystal-community/future.cr
}

@test "schovi/baked_file_system" {
  skiponwindows "Does not build"
  shard_checkout https://github.com/schovi/baked_file_system

  crystal_spec
}

@test "jeromegn/kilt" {
  skip "Liquid spec is broken (https://github.com/jeromegn/kilt/issues/30)"
  skiponwindows "Does not build"
  shard_checkout https://github.com/jeromegn/kilt

  crystal_spec
}

@test "sumpycr/stumpy_core" {
  shard_checkout https://github.com/stumpycr/stumpy_core

  crystal_spec
}

@test "luckyframework/lucky_task" {
  shard_checkout https://github.com/luckyframework/lucky_task

  crystal_spec
}

# bats test_tags=format
@test "format luckyframework/lucky_task" {
  check_crystal_format https://github.com/luckyframework/lucky_task
}

@test "spider-gazelle/bindata" {
  shard_checkout https://github.com/spider-gazelle/bindata

  crystal_spec
}

# bats test_tags=format
@test "format spider-gazelle/bindata" {
  check_crystal_format https://github.com/spider-gazelle/bindata
}

# bats test_tags=openssl
@test "kemalcr/kemal-session" {
  shard_checkout https://github.com/kemalcr/kemal-session

  crystal_spec
}

# bats test_tags=format
@test "format kemalcr/kemal-session" {
  check_crystal_format https://github.com/kemalcr/kemal-session
}

# bats test_tags=openssl
@test "kemalcr/kemal" {
  if [[ "$(crystal env CRYSTAL_VERSION)" =~ ^0\.|^1\.[0-8]\. ]]; then
    skiponwindows "Compiler bug in Crystal < 1.9"
  fi
  skiponwindows "Specs are failing"

  shard_checkout https://github.com/kemalcr/kemal

  crystal_spec
}

# bats test_tags=format
@test "format kemalcr/kemal" {
  check_crystal_format https://github.com/kemalcr/kemal
}

@test "luckyframework/teeplate" {
  skip "Wants to sign git commit"
  skiponwindows "Does not build"
  shard_checkout https://github.com/luckyframework/teeplate

  crystal_spec
}

# bats test_tags=format
@test "format luckyframework/teeplate" {
  check_crystal_format https://github.com/luckyframework/teeplate
}

@test "icyleaf/markd" {
  shard_checkout https://github.com/icyleaf/markd

  crystal_spec
}

# bats test_tags=format
@test "format icyleaf/markd" {
  check_crystal_format https://github.com/icyleaf/markd
}

@test "crystal-lang/json_mapping.cr" {
  skiponwindows "Does not build"
  shard_checkout https://github.com/crystal-lang/json_mapping.cr

  crystal_spec
}

# bats test_tags=format
@test "format crystal-lang/json_mapping.cr" {
  check_crystal_format https://github.com/crystal-lang/json_mapping.cr
}

@test "stumpycr/stumpy_png" {
  skip "Incompatible with modern Crystal"
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/stumpycr/stumpy_png

  crystal_spec
}

# bats test_tags=format
@test "format stumpycr/stumpy_png" {
  check_crystal_format https://github.com/stumpycr/stumpy_png
}

@test "luckyframework/shell-table.cr" {
  skip "Specs are failing"
  shard_checkout https://github.com/luckyframework/shell-table.cr

  crystal_spec
}

# bats test_tags=format
@test "format luckyframework/shell-table.cr" {
  check_crystal_format https://github.com/luckyframework/shell-table.cr
}

# bats test_tags=cmake
@test "kostya/lexbor" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/kostya/lexbor

  $CRYSTAL src/ext/build_ext.cr
  crystal_spec
}

@test "icyleaf/halite" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/icyleaf/halite

  crystal_spec
}

# bats test_tags=format
@test "format icyleaf/halite" {
  check_crystal_format https://github.com/icyleaf/halite
}

@test "jwaldrip/admiral.cr" {
  shard_checkout https://github.com/jwaldrip/admiral.cr

  crystal_spec
}

@test "jeromegn/slang" {
  if [[ "$(crystal env CRYSTAL_VERSION)" =~ ^0\.|^1\.[0-8]\. ]]; then
    skiponwindows "Compiler bug in Crystal < 1.9"
  fi
  skiponwindows "Specs are failing"

  shard_checkout https://github.com/jeromegn/slang

  crystal_spec
}

@test "vladfaust/time_format.cr" {
  shard_checkout https://github.com/vladfaust/time_format.cr

  crystal_spec
}

# bats test_tags=format
@test "format vladfaust/time_format.cr" {
  check_crystal_format https://github.com/vladfaust/time_format.cr
}

@test "mamantoha/http_proxy" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/mamantoha/http_proxy

  crystal_spec
}

# bats test_tags=format
@test "format mamantoha/http_proxy" {
  check_crystal_format https://github.com/mamantoha/http_proxy
}

@test "crystal-community/msgpack-crystal" {
  shard_checkout https://github.com/crystal-community/msgpack-crystal

  crystal_spec
}

# bats test_tags=format
@test "format crystal-community/msgpack-crystal" {
  check_crystal_format https://github.com/crystal-community/msgpack-crystal
}

@test "spider-gazelle/openssl_ext" {
  skiponwindows "Specs are failing"
  shard_checkout https://github.com/spider-gazelle/openssl_ext

  crystal_spec
}

@test "gdotdesign/cr-dotenv" {
  shard_checkout https://github.com/gdotdesign/cr-dotenv

  crystal_spec
}

@test "maiha/pretty.cr" {
  skip "Specs are failing"
  shard_checkout https://github.com/maiha/pretty.cr

  crystal_spec
}

# bats test_tags=format
@test "format maiha/pretty.cr" {
  check_crystal_format https://github.com/maiha/pretty.cr
}

@test "straight-shoota/crinja" {
  skiponwindows "Specs are failing"

  shard_checkout https://github.com/straight-shoota/crinja

  crystal_spec

  cd examples
  bats integration_test.bats
}

# bats test_tags=format
@test "format straight-shoota/crinja" {
  check_crystal_format https://github.com/straight-shoota/crinja
}

