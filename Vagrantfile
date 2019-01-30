Vagrant.configure("2") do |config|
  [%w(debian debian/jessie64), %w(xenial ubuntu/xenial64), %w(xenial32 ubuntu/xenial32)].each do |name, box|
    config.vm.define(name) do |c|
      c.vm.box = box

      c.vm.synced_folder ".", "/vagrant"

      c.vm.provision :shell, inline: %(
        set -e
        export DEBIAN_FRONTEND=noninteractive
        apt-get update

        # crystal deps
        apt-get update \
         && apt-get install -y git build-essential pkg-config software-properties-common curl \
            libpcre3-dev libevent-dev \
            libxml2-dev libyaml-dev libssl-dev zlib1g-dev libsqlite3-dev libgmp-dev \
            libedit-dev libreadline-dev gdb postgresql-client

        add-apt-repository "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-4.0 main" \
         && curl -sSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
         && apt-get update \
         && apt-get install -y llvm-4.0 libclang-4.0-dev

        # bats
        cd /vagrant
        /vagrant/scripts/00-install-bats.sh
      )
    end
  end

  [%w(fedora25 bento/fedora-25), %w(fedora29 bento/fedora-29)].each do |name, box|
    config.vm.define(name) do |c|
      c.vm.box = box

      c.vm.synced_folder ".", "/vagrant"

      c.vm.provision :shell, inline: %(
        set -e

        dnf -y groupinstall "C Development Tools and Libraries"
        dnf -y install git
        dnf -y install gmp-devel libbsd-devel libedit-devel libevent-devel libxml2-devel \
                       libyaml-devel openssl-devel readline-devel redhat-rpm-config
        dnf -y install sqlite-devel postgresql

        curl -sSL https://rpmfind.net/linux/fedora/linux/releases/27/Everything/x86_64/os/Packages/l/llvm-4.0.1-3.fc27.i686.rpm --output llvm.rpm
        curl -sSL https://rpmfind.net/linux/fedora/linux/releases/27/Everything/x86_64/os/Packages/l/llvm-devel-4.0.1-3.fc27.i686.rpm --output llvm-devel.rpm
        curl -sSL https://rpmfind.net/linux/fedora/linux/releases/27/Everything/x86_64/os/Packages/l/llvm-libs-4.0.1-3.fc27.i686.rpm --output llvm-libs.rpm
        curl -sSL https://rpmfind.net/linux/fedora-secondary/releases/27/Everything/i386/os/Packages/c/clang-libs-4.0.1-5.fc27.i686.rpm --output clang-libs.rpm
        curl -sSL https://rpmfind.net/linux/fedora/linux/updates/27/x86_64/Packages/l/libgcc-7.3.1-6.fc27.i686.rpm --output libgcc.rpm
        curl -sSL https://rpmfind.net/linux/fedora/linux/releases/27/Everything/x86_64/os/Packages/c/compiler-rt-4.0.1-4.fc27.i686.rpm --output compiler-rt.rpm
        dnf -y install ./llvm.rpm ./llvm-devel.rpm ./llvm-libs.rpm ./clang-libs.rpm ./libgcc.rpm ./compiler-rt.rpm

        # bats
        cd /vagrant
        /vagrant/scripts/00-install-bats.sh
      )
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end
end
