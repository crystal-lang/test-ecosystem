#!/bin/sh
set -e

git clone https://github.com/sstephenson/bats.git
cd bats
./install.sh /usr/local
