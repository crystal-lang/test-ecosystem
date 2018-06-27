# test-ecosystem

Smoke test for crystal releases. It will allow testing of built artifacts using Docker, Vagrant or local environments.

## Usage

Define the artifacts of the version to stress in `crystal-versions.env` run the specific make target.

* `docker_debian8_deb` and `docker_debian9_deb` will check the `.deb` in the according debian docker image.

* `docker_debian8_i386_deb` and `docker_xenial_i386_deb` will check the 32-bits `.deb` in the according debian/ubuntu docker image.
  * Note: (debian8 seems to have issues linking the crystal compiler [ref](https://github.com/crystal-lang/crystal/issues/1269))

* `docker_debian8_targz` will check the `.tar.gz` in the according debian docker image.
  * Note: There are some issues making the bundled `libgc.a` be grabbed by the linker, but it does work in `docker_debian8_deb`

* `docker_build` will check the docker `-build` image.

* `vagrant_debian8_deb` will check the `.deb` in the according debian vagrant machine.

* `vagrant_xenial32_deb` will check the `.deb` in the according 32-bits ubuntu vagrant machine.

* `vagrant_fedora25_rpm` will check the `.rpm` in the according fedora vagrant maching.

* `local_darwin` will check the osx `tar.gz` in the local osx machine

* `local_linux_deb` will check the `.deb` in the local linux machine
