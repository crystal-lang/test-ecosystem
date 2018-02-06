#!/usr/bin/env bats

@test "crystal compiler" {
  pushd $REPOS_DIR/crystal-lang/crystal

  # Grab current libgc of crystal using crystal env
  # It should be something like:
  # export LIBRARY_PATH=/usr/lib/crystal/lib/
  TEMP=$(crystal env | grep CRYSTAL_PATH)
  export LIBRARY_PATH=${TEMP#CRYSTAL_PATH=}

  make crystal std_spec compiler_spec
  popd
}
