#!/bin/bash

apt-get update && \
  apt-get install -y libmagic-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

