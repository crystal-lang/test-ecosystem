#!/bin/bash

# llvm libclang
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh 13
apt-get install -y libclang-13-dev
ln -sf /usr/bin/ld.lld-13 /usr/bin/ld.lld
export LLVM_CONFIG=/usr/bin/llvm-config-13
