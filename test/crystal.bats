#!/usr/bin/env bats

function setup_file() {
  load helper/common.bash

  git_checkout https://github.com/crystal-lang/crystal
}

function setup() {
  load helper/common.bash
}

@test "$CRYSTAL --version" {
  $CRYSTAL --version
}

@test "$CRYSTAL env" {
  $CRYSTAL env
}

@test "crystal manual specs" {
  "bin/crystal${BAT}" spec spec/manual/https_client_spec.cr
}
