#! /usr/bin/env bash
#
# This script makes is a helper to run selective bats tests locally.
#
# Usage:
#   ./run-bats.sh                      # Run all bats tests locally
#   ./run-bats.sh bats/01-shards.bats  # Run specific bats tests locally
set -e

source variables.sh

crystal --version
shards --version

if [ $# -eq 0 ]; then
  bats $(dirname $0)/bats/
else
  bats $@
fi
