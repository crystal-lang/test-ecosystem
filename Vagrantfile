Vagrant.configure("2") do |config|
  [%w(debian debian/jessie64)].each do |name, box|
    config.vm.define(name) do |c|
      c.vm.box = box

      c.vm.synced_folder ".", "/vagrant"

      c.vm.provision :shell, inline: %(
        set -e
        export DEBIAN_FRONTEND=noninteractive
        apt-get update

        # docker
        apt-get -y install apt-transport-https ca-certificates curl gnupg2 python-pip software-properties-common
        curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
        apt-get update
        apt-get -y install docker-ce
        pip install docker-compose
        usermod -aG docker vagrant
        /etc/init.d/docker start

        # crystal deps
        apt-get update \
         && apt-get install -y git build-essential pkg-config software-properties-common curl \
            libpcre3-dev libevent-dev \
            libxml2-dev libyaml-dev libssl-dev zlib1g-dev libsqlite3-dev libgmp-dev \
            libedit-dev libreadline-dev gdb

        add-apt-repository "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-4.0 main" \
         && curl -sSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
         && apt-get update \
         && apt-get install -y llvm-4.0

        # bats & services
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
