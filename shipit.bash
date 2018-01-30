#!/bin/bash -ex
for VM in debian # debian32
do
  vagrant up ${VM}
  vagrant ssh ${VM} -c 'cd /vagrant && ./clone-and-run.sh'
done
