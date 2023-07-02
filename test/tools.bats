#!/usr/bin/env bats

# These tests cover applications that are used as tools for Crystal projects.

function setup() {
  load helper/common.bash
}

@test "crystal-ameba/ameba" {
  skiponwindows "Timeout"
  shard_checkout https://github.com/crystal-ameba/ameba

  if [[ "$(crystal env CRYSTAL_VERSION)" =~ ^1.9. ]]; then
    git merge origin/update-to-work-with-crystal-nightly || true
  fi

  crystal_spec
}
