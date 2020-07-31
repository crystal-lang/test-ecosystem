#!/bin/bash
set -e

which crystal
crystal --version
crystal env

which shards
shards --version

uname -a

# bats $(dirname $0)/../bats/
# bats $(dirname $0)/../bats/00-crystal-init-spec.bats
# bats $(dirname $0)/../bats/01-shards.bats
# bats $(dirname $0)/../bats/10-crystal-db.bats
bats $(dirname $0)/../bats/40-web-frameworks-lucky.bats

crystal --version
shards --version
uname -a
