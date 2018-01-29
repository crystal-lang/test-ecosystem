#!/bin/sh
set -e

REPOS_DIR=/tmp/repos

REPOS_DIR=$REPOS_DIR ./setup/01-clone-repos.sh
REPOS_DIR=$REPOS_DIR bats ./bats
