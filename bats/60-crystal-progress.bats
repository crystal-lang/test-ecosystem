#!/usr/bin/env bats

@test "crystal compiler (release)" {
  pushd $REPOS_DIR/crystal-lang/crystal

  make clean

  # skip wrapper script in case the crystal compiler points to a wrapper
  bin_crystal=$(dirname $(dirname $(which crystal)))/.build/crystal
  if test -f "$bin_crystal"; then
    mkdir -p .build
    cp $bin_crystal .build/crystal
    touch src/compiler/crystal.cr
  fi

  make clean_cache crystal release=1 FLAGS="--no-debug"

  popd
}

@test "crystal compiler (2nd gen)" {
  pushd $REPOS_DIR/crystal-lang/crystal

  touch src/compiler/crystal.cr
  make crystal release=1 FLAGS="--no-debug"

  popd
}
