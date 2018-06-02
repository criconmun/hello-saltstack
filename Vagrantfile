# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "ubuntu/xenial64"
NODE_COUNT = 1
SALT_VERION = 2018.3

Vagrant.configure("2") do |config|

  # Master node
  config.vm.define "master" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "master"
    subconfig.vm.network "private_network", ip: "192.168.33.10"

    # Upload salt config files
    subconfig.vm.provision "file", source: "salt/master", destination: "/tmp/master"
    subconfig.vm.provision "file", source: "salt/host", destination: "/tmp/host"

    # Install and configure salt
    subconfig.vm.provision "shell", inline: <<-SHELL
      # Install salt
      apt-get update && apt-get install -y salt-master
      # Move config files to the right locations
      mv /tmp/master /etc/salt/master
      mkdir -p /etc/salt/autosign_grains/ && mv /tmp/host /etc/salt/autosign_grains/host
      # Create the /srv/salt directory
      mkdir -p /srv/salt
      # Restart salt daemon
      systemctl restart salt-master
    SHELL

    # Folder to store releases
    config.vm.synced_folder "release/", "/srv/salt/web"

  end

  # Minion nodes
  (1..NODE_COUNT).each do |i|
    config.vm.define "minion#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "minion#{i}"
      subconfig.vm.network "private_network", ip: "192.168.33.2#{i}"

      # Upload salt config files
      subconfig.vm.provision "file", source: "salt/minion", destination: "/tmp/minion"

      # Install and configure salt
      subconfig.vm.provision "shell", inline: <<-SHELL
        # Install salt
        apt-get update && apt-get install -y salt-minion
        # Move config files to the right locations
        mv /tmp/minion /etc/salt/minion
        # Restart salt daemon
        systemctl restart salt-minion
      SHELL

    end
  end

  # Generic shell provisioner - stuff to do on all vms
  config.vm.provision "shell", inline: <<-SHELL
    # Add official salt repo
    wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/#{SALT_VERION}/SALTSTACK-GPG-KEY.pub | apt-key add -
    apt-add-repository 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/#{SALT_VERION} xenial main'
    # Enable name resolution
    apt-get update && apt-get install -y avahi-daemon libnss-mdns
  SHELL

end
