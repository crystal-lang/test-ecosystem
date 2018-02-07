#!/bin/bash
set -e

pushd ~
git clone https://github.com/sstephenson/bats.git
pushd bats
./install.sh /usr/local
popd
popd
