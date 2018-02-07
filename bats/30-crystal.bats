#!/usr/bin/env bats

@test "crystal compiler" {
  pushd $REPOS_DIR/crystal-lang/crystal

  make crystal std_spec compiler_spec

  popd
}
