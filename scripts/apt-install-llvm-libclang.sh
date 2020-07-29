#!/bin/bash

# llvm libclang
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh 10
apt-get install -y libclang-10-dev
ln -sf /usr/bin/ld.lld-10 /usr/bin/ld.lld
export LLVM_CONFIG=/usr/bin/llvm-config-10
