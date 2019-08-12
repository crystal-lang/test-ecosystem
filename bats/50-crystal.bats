#!/usr/bin/env bats

@test "crystal manual specs" {
  pushd $REPOS_DIR/crystal-lang/crystal

  crystal spec/manual/https_client_spec.cr

  popd
}

@test "crystal compiler" {
  pushd $REPOS_DIR/crystal-lang/crystal

  make clean crystal
  # make std_spec compiler_spec

  popd
}
