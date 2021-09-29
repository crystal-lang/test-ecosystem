#!/usr/bin/env bats

@test "test crystal-patterns" {
  pushd $REPOS_DIR/crystal-community/crystal-patterns
  
  for src in creational/*.cr structural/*.cr behavioral/*.cr
  do
    (set -x; crystal run $src)
  done

  popd
}
