#!/bin/sh
set -e

DOCKER_IMAGE_NAME=crystal-0.24.2-test

# CRYSTAL_TAR_GZ=https://github.com/crystal-lang/crystal/releases/download/0.23.1/crystal-0.23.1-3-linux-x86_64.tar.gz
CRYSTAL_TAR_GZ=x86_64/build/crystal-0.24.1-2-linux-x86_64.tar.gz
docker build -t $DOCKER_IMAGE_NAME:debian-8-targz -f Dockerfile-debian-8-targz --build-arg crystal_tar_gz=$CRYSTAL_TAR_GZ ..

CRYSTAL_DEB=x86_64/build/crystal_0.24.1-2_amd64.deb
docker build -t $DOCKER_IMAGE_NAME:debian-8-deb -f Dockerfile-debian-8-deb --build-arg crystal_deb=$CRYSTAL_DEB ..
docker build -t $DOCKER_IMAGE_NAME:debian-9-deb -f Dockerfile-debian-9-deb --build-arg crystal_deb=$CRYSTAL_DEB ..

docker run --rm -v $(pwd)/bats:/bats $DOCKER_IMAGE_NAME:debian-8-targz /bin/sh -c "bats /bats"
docker run --rm -v $(pwd)/bats:/bats $DOCKER_IMAGE_NAME:debian-8-deb /bin/sh -c "bats /bats"
docker run --rm -v $(pwd)/bats:/bats $DOCKER_IMAGE_NAME:debian-9-deb /bin/sh -c "bats /bats"
