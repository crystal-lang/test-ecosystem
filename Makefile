CRYSTAL_DARWING_TARGZ ?= https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-darwin-x86_64.tar.gz
CRYSTAL_LINUX_DEB     ?= https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal_0.24.1-2_amd64.deb
CRYSTAL_LINUX_TARGZ   ?= https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-linux-x86_64.tar.gz

DOCKER_IMAGE_NAME = crystal-test

.PHONY: darwin
darwin:
	curl -L -o /tmp/crystal.tar.gz $(CRYSTAL_DARWING_TARGZ) \
	&& mkdir -p /tmp/crystal \
	&& tar xz -f /tmp/crystal.tar.gz -C /tmp/crystal --strip-component=1 \
	&& PATH=/tmp/crystal/bin:/tmp/crystal/embedded/bin:$$PATH ./clone-and-run.sh

.PHONY: docker_debian8_deb
docker_debian8_deb:
	docker build -t $(DOCKER_IMAGE_NAME):debian8-deb -f ./docker/Dockerfile-debian8-deb --build-arg crystal_deb=$(CRYSTAL_LINUX_DEB) . \
	&& docker run --rm -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian8-deb /bin/bash -c "bats /bats"

.PHONY: docker_debian8_targz
docker_debian8_targz:
	docker build -t $(DOCKER_IMAGE_NAME):debian8-targz -f ./docker/Dockerfile-debian8-targz --build-arg crystal_targz=$(CRYSTAL_LINUX_TARGZ) . \
	&& docker run --rm -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian8-targz /bin/bash -c "bats /bats"

.PHONY: docker_debian9_deb
docker_debian9_deb:
	docker build -t $(DOCKER_IMAGE_NAME):debian9-deb -f ./docker/Dockerfile-debian9-deb --build-arg crystal_deb=$(CRYSTAL_LINUX_DEB) . \
	&& docker run --rm -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian9-deb /bin/bash -c "bats /bats"

crystal/crystal_amd64.deb:
	curl -L -o crystal/crystal_amd64.deb $(CRYSTAL_LINUX_DEB)
