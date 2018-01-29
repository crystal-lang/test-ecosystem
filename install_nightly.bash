#!/bin/bash
sudo ./setup/00-install-bats.sh
make crystal/crystal_amd64.deb
sudo dpkg --force-bad-version -i crystal/crystal_amd64.deb
sudo apt-get install -f -y
./clone-and-run.sh
