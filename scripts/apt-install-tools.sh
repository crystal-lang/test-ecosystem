#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get install -y git mercurial software-properties-common lsb-release curl wget \
                   ca-certificates apt-transport-https postgresql-client
