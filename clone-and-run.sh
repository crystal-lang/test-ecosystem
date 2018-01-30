#!/bin/sh
set -e

which crystal
crystal --version

which shards
shards --version

export REPOS_DIR=/tmp/repos
./setup/10-clone-repos.sh

docker-compose up -d
docker-compose exec postgres createdb crystal

bats ./bats

