#!/bin/bash
set -e

which crystal
crystal --version
crystal env

which shards
shards --version

uname -a

bats $(dirname $0)/../bats/

crystal --version
shards --version
uname -a
