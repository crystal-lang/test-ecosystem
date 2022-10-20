#!/usr/bin/env bats

@test "webmock.cr specs" {
  pushd $REPOS_DIR/manastech/webmock.cr
  shards
  crystal spec
  popd
}

# DISABLED: crystal_lib dependency clang.cr is incompatible with LLVM > 8
# @test "crystal_lib specs" {
#   pushd $REPOS_DIR/crystal-lang/crystal_lib
#   shards
#   crystal spec
#   popd
# }
