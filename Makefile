include crystal-versions.env

CRYSTAL_DARWIN_TARGZ       ?= ## url or path to crystal-{version}-{package}-darwin-x86_64.tar.gz
CRYSTAL_LINUX_TARGZ        ?= ## url or path to crystal-{version}-{package}-linux-x86_64.tar.gz
CRYSTAL_LINUX_DEB          ?= ## url or path to crystal_{version}-{package}_amd64.deb
CRYSTAL_LINUX32_DEB        ?= ## url or path to crystal_{version}-{package}_i386.deb
CRYSTAL_LINUX_RPM          ?= ## url or path to crystal-{version}-{package}.x86_64.rpm
CRYSTAL_LINUX32_RPM        ?= ## url or path to crystal-{version}-{package}.i386.rpm
CRYSTAL_DOCKER_BUILD_IMAGE ?= ## full docker image name to use crystallang/crystal:{version}-build

DOCKER_IMAGE_NAME = crystal-test
DOCKER_NETWORK = crystal-test

SHELL := /bin/bash
BINARIES = binaries

.PHONY: local
local: services_on_host
	rm -Rf /tmp/crystal
	mkdir /tmp/crystal
	source ./docker/hosts.local.env \
	&& source ./scripts/default-options.env \
	&& PATH=$$LOCAL_CRYSTAL:$$LOCAL_SHARDS:$$PATH ./clone-and-run-local.sh

.PHONY: local_darwin
local_darwin: $(BINARIES)/darwin.tar.gz services_on_host
	rm -Rf /tmp/crystal
	mkdir /tmp/crystal
	tar xz -f $(BINARIES)/darwin.tar.gz -C /tmp/crystal --strip-component=1
	source ./docker/hosts.local.env \
	&& source ./scripts/default-options.env \
	&& PATH=/tmp/crystal/bin:/tmp/crystal/embedded/bin:$$PATH ./clone-and-run-local.sh

.PHONY: local_linux_deb
local_linux_deb: $(BINARIES)/linux.deb services_on_host
	sudo dpkg --force-bad-version -i $(BINARIES)/linux.deb || echo 'deps missing'
	sudo apt-get install -f -y
	source ./docker/hosts.local.env \
	&& source ./scripts/default-options.env \
	&& LIBRARY_PATH=/usr/lib/crystal/lib/ ./clone-and-run-local.sh

.PHONY: local_linux32_deb
local_linux32_deb: $(BINARIES)/linux32.deb services_on_host
	sudo dpkg --force-bad-version -i $(BINARIES)/linux32.deb || echo 'deps missing'
	sudo apt-get install -f -y
	source ./docker/hosts.local.env \
	&& source ./scripts/default-options.env \
	&& LIBRARY_PATH=/usr/lib/crystal/lib/ ./clone-and-run-local.sh

.PHONY: local_fedora_rpm
local_fedora_rpm: $(BINARIES)/linux.rpm services_on_host
	sudo dnf -y install $(BINARIES)/linux.rpm
	source ./docker/hosts.local.env \
	&& source ./scripts/default-options.env \
	&& LIBRARY_PATH=/usr/lib/crystal/lib/ ./clone-and-run-local.sh

define run_bats_in_docker
	docker run --rm --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats -v $(CURDIR)/samples:/samples -v $(CURDIR)/shards_cache:/shards_cache $(DOCKER_IMAGE_NAME):$(1) $2 /bin/bash -c "source ./scripts/default-options.env && /scripts/10-clone-repos.sh && /scripts/20-run-bats.sh"
endef

# replace calls to run_bats_in_docker with run_shell_in_docker to get an interactive shell
define run_shell_in_docker
	docker run --rm -it --env-file=./docker/hosts.network.env --network=$(DOCKER_NETWORK) -v $(CURDIR)/bats:/bats -v $(CURDIR)/samples:/samples -v $(CURDIR)/shards_cache:/shards_cache $(DOCKER_IMAGE_NAME):$(1) $2 /bin/bash
endef

.PHONY: docker_debian8_deb
docker_debian8_deb: $(BINARIES)/linux.deb services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):debian8-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(BINARIES)/linux.deb --build-arg debian_docker_image="debian:8" .
	$(call run_bats_in_docker,debian8-deb)

.PHONY: docker_debian8_i386_deb
docker_debian8_i386_deb: $(BINARIES)/linux32.deb services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):debian8-i386-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(BINARIES)/linux32.deb --build-arg debian_docker_image="i386/debian:8" --build-arg library_path=/usr/lib/crystal/lib/ .
	$(call run_bats_in_docker,debian8-i386-deb,linux32)

.PHONY: docker_xenial_i386_deb
docker_xenial_i386_deb: $(BINARIES)/linux32.deb services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):xenial-i386-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(BINARIES)/linux32.deb --build-arg debian_docker_image="i386/ubuntu:xenial" --build-arg library_path=/usr/lib/crystal/lib/ .
	$(call run_bats_in_docker,xenial-i386-deb,linux32)

.PHONY: docker_debian8_targz
docker_debian8_targz: $(BINARIES)/linux.tar.gz services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):debian8-targz -f ./docker/Dockerfile-debian-targz --build-arg crystal_targz=$(BINARIES)/linux.tar.gz --build-arg debian_docker_image="debian:8" .
	$(call run_bats_in_docker,debian8-targz)

.PHONY: docker_debian9_deb
docker_debian9_deb: $(BINARIES)/linux.deb services_on_network
	docker build -t $(DOCKER_IMAGE_NAME):debian9-deb -f ./docker/Dockerfile-debian-deb --build-arg crystal_deb=$(BINARIES)/linux.deb --build-arg debian_docker_image="debian:9" .
	$(call run_bats_in_docker,debian9-deb)

.PHONY: docker_build
docker_build: services_on_network
	docker build --pull -t $(DOCKER_IMAGE_NAME):docker-build -f ./docker/Dockerfile-docker-build --build-arg docker_image=$(CRYSTAL_DOCKER_BUILD_IMAGE) .
	$(call run_bats_in_docker,docker-build)

.PHONY: vagrant_debian8_deb
vagrant_debian8_deb: services_on_host
	vagrant up debian
	vagrant ssh debian -c 'cd /vagrant && make local_linux_deb SERVICES=stub' -- -R 5432:localhost:5432 -R 3306:localhost:3306 -R 6379:localhost:6379
	vagrant destroy debian -f

.PHONY: vagrant_xenial_deb
vagrant_xenial_deb: services_on_host
	vagrant up xenial
	vagrant ssh xenial -c 'cd /vagrant && make local_linux_deb SERVICES=stub' -- -R 5432:localhost:5432 -R 3306:localhost:3306 -R 6379:localhost:6379
	vagrant destroy xenial -f

.PHONY: vagrant_xenial32_deb
vagrant_xenial32_deb: services_on_host
	vagrant up xenial32
	vagrant ssh xenial32 -c 'cd /vagrant && make local_linux32_deb SERVICES=stub' -- -R 5432:localhost:5432 -R 3306:localhost:3306 -R 6379:localhost:6379
	vagrant destroy xenial32 -f

.PHONY: vagrant_bionic_deb
vagrant_bionic_deb: services_on_host
	vagrant up bionic
	vagrant ssh bionic -c 'cd /vagrant && make local_linux_deb SERVICES=stub' -- -R 5432:localhost:5432 -R 3306:localhost:3306 -R 6379:localhost:6379
	vagrant destroy bionic -f

.PHONY: vagrant_fedora_rpm
vagrant_fedora_rpm: $(BINARIES)/linux.rpm services_on_host
	vagrant up fedora
	vagrant ssh fedora -c 'cd /vagrant && make local_fedora_rpm SERVICES=stub' -- -R 5432:localhost:5432 -R 3306:localhost:3306 -R 6379:localhost:6379
	vagrant destroy fedora -f

define prepare_services
	sleep 10
	docker-compose exec postgres createdb -U postgres crystal
	docker-compose exec postgres createdb -U postgres test_app_development
	docker-compose exec mysql mysql -uroot --execute="CREATE DATABASE test_granite"
endef

.PHONY: services_on_host
services_on_host:
ifneq ($(SERVICES),stub)
	# services are mounted with port mapping instead of
	# been accessed as separate host in a docker network
	docker-compose down -v
	docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d
	$(call prepare_services)
endif

.PHONY: services_on_network
services_on_network:
	# for performing the specs in crystal compilers in
	# a docker container, the services are used as different
	# hosts in a docker network
	docker-compose down -v
	docker network inspect $(DOCKER_NETWORK) || docker network create $(DOCKER_NETWORK)
	docker-compose -f docker-compose.yml -f docker-compose.network.yml up -d
	$(call prepare_services)

# targets to prepare binaries in $(BINARIES) folder and avoid downloading them multiple times

define prepare_binary
	mkdir -p $(BINARIES)
	if [[ "$(1)" =~ ^http(s?):\/\/ ]]; \
	then curl -L -o $(BINARIES)/$(2) "$(1)"; \
	else cp "$(1)" $(BINARIES)/$(2); \
	fi
endef

.PHONY: binaries
binaries: $(BINARIES)/darwin.tar.gz $(BINARIES)/linux.deb $(BINARIES)/linux.tar.gz $(BINARIES)/linux32.deb $(BINARIES)/linux.rpm $(BINARIES)/linux32.rpm

clean: clean_vagrant clean_services
	rm -Rf $(BINARIES)/*
	rm -Rf shards_cache

clean_services:
	docker-compose down -v

clean_vagrant:
	vagrant destroy -f debian xenial xenial32 bionic fedora

$(BINARIES)/darwin.tar.gz: crystal-versions.env
	$(call prepare_binary,$(CRYSTAL_DARWIN_TARGZ),darwin.tar.gz)

$(BINARIES)/linux.deb: crystal-versions.env
	$(call prepare_binary,$(CRYSTAL_LINUX_DEB),linux.deb)

$(BINARIES)/linux.tar.gz: crystal-versions.env
	$(call prepare_binary,$(CRYSTAL_LINUX_TARGZ),linux.tar.gz)

$(BINARIES)/linux32.deb: crystal-versions.env
	$(call prepare_binary,$(CRYSTAL_LINUX32_DEB),linux32.deb)

$(BINARIES)/linux.rpm: crystal-versions.env
	$(call prepare_binary,$(CRYSTAL_LINUX_RPM),linux.rpm)

$(BINARIES)/linux32.rpm: crystal-versions.env
	$(call prepare_binary,$(CRYSTAL_LINUX32_RPM),linux32.rpm)
