Vagrant.configure("2") do |config|
  [%w(debian debian/jessie64)].each do |name, box|
    config.vm.define(name) do |c|
      c.vm.box = box

      c.vm.synced_folder ".", "/vagrant", type: "nfs"

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
        apt-get -y install libssl-dev libxml2-dev libsqlite3-dev libyaml-dev libgmp-dev git
        wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
        add-apt-repository 'deb http://apt.llvm.org/jessie/ llvm-toolchain-jessie-4.0 main'
        apt-get update
        apt-get -y install llvm-4.0 libreadline-dev

        # bats & services
        cd /vagrant
        /vagrant/setup/00-install-bats.sh

        # crystal compiler
        make crystal/crystal_amd64.deb
        dpkg --force-bad-version -i crystal/crystal_amd64.deb || echo 'deps missing'
        apt-get install -f -y
      )
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end
end
