#!/bin/sh
set -e

export REPOS_DIR=/tmp/repos
./scripts/10-clone-repos.sh
./scripts/20-run-bats.sh
