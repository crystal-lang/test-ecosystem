#!/usr/bin/env bats

@test "crystal compiler" {
  pushd $REPOS_DIR/crystal-lang/crystal

  TEMP=$(crystal env | grep CRYSTAL_PATH)
  export LIBRARY_PATH=${TEMP#CRYSTAL_PATH=}
  # export LIBRARY_PATH=/usr/lib/crystal/lib/

  make crystal std_spec compiler_spec
  popd
}
