#!/usr/bin/env bats

# These tests cover applications that are used as tools for Crystal projects.

function setup() {
  load helper/common.bash
}

@test "crystal-ameba/ameba" {
  skiponwindows "Timeout"
  shard_checkout https://github.com/crystal-ameba/ameba

  if [[ "$(crystal env CRYSTAL_VERSION)" =~ ^1.9. ]]; then
    if git show-ref --quiet refs/remotes/origin/update-to-work-with-crystal-nightly; then
      git diff ...refs/remotes/origin/update-to-work-with-crystal-nightly | git apply
    fi
  fi

  crystal_spec
}

# bats test_tags=format
@test "format crystal-ameba/ameba" {
  check_crystal_format https://github.com/crystal-ameba/ameba
}
