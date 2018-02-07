CRYSTAL_DARWING_TARGZ ?= https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-darwin-x86_64.tar.gz
CRYSTAL_LINUX_DEB     ?= https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal_0.24.1-2_amd64.deb
CRYSTAL_LINUX_TARGZ   ?= https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-linux-x86_64.tar.gz

DOCKER_IMAGE_NAME = crystal-test
DOCKER_NETWORK = crystal-test

.PHONY: darwin
darwin:
	# services are mounted with port mapping instead of
	# been accessed as separate host in a docker network
	docker-compose down -v
	docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d
	sleep 5
	docker-compose exec postgres createdb crystal
	docker-compose exec postgres createdb test_app_development
	curl -L -o /tmp/crystal.tar.gz $(CRYSTAL_DARWING_TARGZ)
	mkdir -p /tmp/crystal
	tar xz -f /tmp/crystal.tar.gz -C /tmp/crystal --strip-component=1
	export $(cat ./docker/hosts.local.env | xargs) \
	&& PATH=/tmp/crystal/bin:/tmp/crystal/embedded/bin:$$PATH ./clone-and-run-local.sh

.PHONY: services
services:
	# for performing the specs in crystal compilers in
	# a docker container, the services are used as different
  # hosts in a docker network
	docker-compose down -v
	docker network inspect $(DOCKER_NETWORK) || docker network create $(DOCKER_NETWORK)
	docker-compose -f docker-compose.yml -f docker-compose.network.yml up -d
	sleep 5
	docker-compose exec postgres createdb crystal
	docker-compose exec postgres createdb test_app_development

.PHONY: docker_debian8_deb
docker_debian8_deb: services
	docker build -t $(DOCKER_IMAGE_NAME):debian8-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(CRYSTAL_LINUX_DEB) --build-arg debian_docker_image="debian:8" .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian8-deb /bin/bash -c "/scripts/20-run-bats.sh"

.PHONY: docker_debian8_targz
docker_debian8_targz: services
	curl -L -o ./tmp/crystal.tar.gz $(CRYSTAL_LINUX_TARGZ)
	docker build -t $(DOCKER_IMAGE_NAME):debian8-targz -f ./docker/Dockerfile-debian-targz --build-arg crystal_targz=./tmp/crystal.tar.gz --build-arg debian_docker_image="debian:8" .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian8-targz /bin/bash -c "/scripts/20-run-bats.sh"

.PHONY: docker_debian9_deb
docker_debian9_deb: services
	docker build -t $(DOCKER_IMAGE_NAME):debian9-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(CRYSTAL_LINUX_DEB) --build-arg debian_docker_image="debian:9" .
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats $(DOCKER_IMAGE_NAME):debian9-deb /bin/bash -c "/scripts/20-run-bats.sh"
