#!/usr/bin/env bats

@test "crystal manual specs" {
  pushd $REPOS_DIR/crystal-lang/crystal

  crystal spec/manual/https_client_spec.cr

  popd
}

@test "crystal compiler" {
  pushd $REPOS_DIR/crystal-lang/crystal

  make clean

  # skip wrapper script in case the crystal compiler points to a wrapper
  bin_crystal=$(dirname $(dirname $(which crystal)))/.build/crystal
  if test -f "$bin_crystal"; then
    mkdir -p .build
    cp $bin_crystal .build/crystal
    touch src/compiler/crystal.cr
  fi

  make clean_cache crystal
  make std_spec compiler_spec

  popd
}

# TODO add llvm-ir
