#!/usr/bin/env bats

@test "crystal compiler (release)" {
  pushd $REPOS_DIR/crystal-lang/crystal

  make clean crystal release=1 FLAGS="--no-debug"

  popd
}

@test "crystal compiler (2nd gen)" {
  pushd $REPOS_DIR/crystal-lang/crystal

  touch src/compiler/crystal.cr
  make crystal release=1 FLAGS="--no-debug"

  popd
}
