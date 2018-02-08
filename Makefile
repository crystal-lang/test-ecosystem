include crystal-versions.env

CRYSTAL_DARWING_TARGZ      ?= ## url to crystal-{version}-{package}-darwin-x86_64.tar.gz
CRYSTAL_LINUX_DEB          ?= ## url to crystal_{version}-{package}_amd64.deb
CRYSTAL_LINUX_TARGZ        ?= ## url to crystal-{version}-{package}-linux-x86_64.tar.gz
CRYSTAL_DOCKER_BUILD_IMAGE ?= ## full docker image name to use crystallang/crystal:{version}-build

DOCKER_IMAGE_NAME = crystal-test
DOCKER_NETWORK = crystal-test

SHELL := /bin/bash

.PHONY: local_darwin
local_darwin: services_on_host
	curl -L -o /tmp/crystal.tar.gz $(CRYSTAL_DARWING_TARGZ)
	mkdir -p /tmp/crystal
	tar xz -f /tmp/crystal.tar.gz -C /tmp/crystal --strip-component=1
	source ./docker/hosts.local.env \
	&& PATH=/tmp/crystal/bin:/tmp/crystal/embedded/bin:$$PATH ./clone-and-run-local.sh

.PHONY: local_linux_deb
local_linux_deb: services_on_host
	curl -L -o ./tmp/crystal.deb $(CRYSTAL_LINUX_DEB)
	sudo dpkg --force-bad-version -i ./tmp/crystal.deb || echo 'deps missing'
	sudo apt-get install -f -y
	source ./docker/hosts.local.env \
	&& LIBRARY_PATH=/usr/lib/crystal/lib/ ./clone-and-run-local.sh

.PHONY: docker_debian8_deb
docker_debian8_deb: services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):debian8-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(CRYSTAL_LINUX_DEB) --build-arg debian_docker_image="debian:8" .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian8-deb /bin/bash -c "/scripts/20-run-bats.sh"

.PHONY: docker_debian8_targz
docker_debian8_targz: services_on_network
	curl -L -o ./tmp/crystal.tar.gz $(CRYSTAL_LINUX_TARGZ)
	docker build -t $(DOCKER_IMAGE_NAME):debian8-targz -f ./docker/Dockerfile-debian-targz --build-arg crystal_targz=./tmp/crystal.tar.gz --build-arg debian_docker_image="debian:8" .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian8-targz /bin/bash -c "/scripts/20-run-bats.sh"

.PHONY: docker_debian9_deb
docker_debian9_deb: services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):debian9-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(CRYSTAL_LINUX_DEB) --build-arg debian_docker_image="debian:9" .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian9-deb /bin/bash -c "/scripts/20-run-bats.sh"

.PHONY: docker_build
docker_build: services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):docker-build -f ./docker/Dockerfile-docker-build --build-arg docker_image=$(CRYSTAL_DOCKER_BUILD_IMAGE) .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):docker-build /bin/bash -c "/scripts/20-run-bats.sh"

.PHONY: vagrant_debian8_deb
vagrant_debian8_deb: services_on_host
	vagrant up debian
	vagrant ssh debian -c 'cd /vagrant && make local_linux_deb SERVICES=stub' -- -R 5432:localhost:5432 -R 3306:localhost:3306 -R 6379:localhost:6379
	vagrant destroy debian -f

.PHONY: services_on_host
services_on_host:
ifneq ($(SERVICES),stub)
	# services are mounted with port mapping instead of
	# been accessed as separate host in a docker network
	docker-compose down -v
	docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d
	sleep 5
	docker-compose exec postgres createdb crystal
	docker-compose exec postgres createdb test_app_development
endif

.PHONY: services_on_network
services_on_network:
	# for performing the specs in crystal compilers in
	# a docker container, the services are used as different
  # hosts in a docker network
	docker-compose down -v
	docker network inspect $(DOCKER_NETWORK) || docker network create $(DOCKER_NETWORK)
	docker-compose -f docker-compose.yml -f docker-compose.network.yml up -d
	sleep 5
	docker-compose exec postgres createdb crystal
	docker-compose exec postgres createdb test_app_development
