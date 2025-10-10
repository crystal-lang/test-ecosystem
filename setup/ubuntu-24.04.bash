#!/bin/bash

sudo apt-get update && \
  sudo apt-get install -y libmagic-dev && \
  sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

