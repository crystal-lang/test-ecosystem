#! /usr/bin/env bash
set -e

source variables.sh

./scripts/10-clone-repos.sh
./scripts/20-run-bats.sh
