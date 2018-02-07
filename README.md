# test-ecosystem

Smoke test for crystal releases. It will allow testing of built artifacts using Docker, Vagrant or local environments.

## Usage

Define the artifacts of the version to stress in `crystal-versions.env` run the specific make target.

* `docker_debian8_deb` and `docker_debian9_deb` will check the `.deb` in the according debian docker image.

* `docker_debian8_targz` will check the `.tar.gz` in the according debian docker image.

* `vagrant_debian8_deb` will check the `.deb` in the according debian docker image.

* `local_darwin` will check the osx `tar.gz` in the local osx machine

* `local_linux_deb` will check the `.deb` in the local linux machine
