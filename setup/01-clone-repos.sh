#!/bin/sh
set -e

rm -rf $REPOS_DIR
mkdir -p $REPOS_DIR
cd $REPOS_DIR

git clone https://github.com/crystal-lang/crystal-db.git
cd crystal-db && git checkout crystal/v0.24.0 && cd ..

git clone https://github.com/crystal-lang/crystal-mysql.git
cd crystal-mysql && git checkout crystal/v0.24.1 && cd ..

git clone https://github.com/will/crystal-pg.git
cd crystal-pg && git checkout crystalv024 && cd ..

git clone https://github.com/crystal-lang/crystal-sqlite3.git

git clone https://github.com/kemalcr/kemal.git
# cd kemal && git checkout v0.21.0 && cd ..
cd kemal && git checkout master && cd ..

git clone https://github.com/bcardiff/have_files
cd have_files && git checkout crystal/v0.24.0 && cd ..
git clone https://github.com/bcardiff/teeplate
cd teeplate && git checkout crystal/v0.24.0 && cd ..
git clone https://github.com/bcardiff/lucky_cli
cd lucky_cli && git checkout crystal/v0.24.0 && cd ..
git clone https://github.com/bcardiff/lucky.git
cd lucky && git checkout crystal/v0.24.1 && cd ..

git clone https://github.com/veelenga/slang
cd slang && git checkout feat/crystal-0.24 && cd ..
git clone https://github.com/samueleaton/sentry
cd sentry && git checkout update-process-init && cd ..
git clone https://github.com/bcardiff/cli
cd cli && git checkout crystal/v0.24.0 && cd ..
git clone https://github.com/bcardiff/amber.git
cd amber && git checkout crystal/v0.24.1 && cd ..
# requires redis

