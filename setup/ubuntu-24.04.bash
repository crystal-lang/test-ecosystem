#!/bin/bash

sudo apt-get update && \
  sudo apt-get install -y libmagic-dev etcd-server && \
  sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

