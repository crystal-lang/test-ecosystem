#!/bin/bash -ex
for VM in debian debian32
do
  vagrant up ${VM}
  vagrant ssh ${VM} -c 'cd /vagrant && ./install_nightly.bash'
  vagrant ssh ${VM} -c 'bats /vagrant/bats'
done
