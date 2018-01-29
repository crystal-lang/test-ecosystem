Vagrant.configure("2") do |config|
  [%w(debian bento/debian-7.8), %w(debian32 bento/debian-7.8-i386)].each do |name, box|
    config.vm.define(name) do |c|
      c.vm.box = box

      c.vm.synced_folder ".", "/vagrant"

      c.vm.provision :shell, inline: %(
        set -e
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get -y install libssl-dev libxml2-dev libsqlite3-dev libyaml-dev git
      )
    end
  end
end
