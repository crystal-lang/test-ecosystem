#!/usr/bin/env sh
#
# This helper updates all references to the previous Crystal release as bootstrap version with a new release.
#
# Usage:
#
#    scripts/release-update.sh 1.3.0
#
# See Crystal release checklist: https://github.com/crystal-lang/distribution-scripts/blob/master/processes/crystal-release.md#post-release
set -eu

CRYSTAL_VERSION=$1

# Update `previous_crystal_release` in CI workflow
sed -i -E "s|/[0-9.]+/crystal-[0-9.]+-[0-9]-|/$CRYSTAL_VERSION/crystal-$CRYSTAL_VERSION-1-|" .github/workflows/test-crystal-shards.yml
