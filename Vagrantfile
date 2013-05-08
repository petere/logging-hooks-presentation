# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise"

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file = "default.pp"
    puppet.module_path = "modules"
  end

  config.vm.forward_port 50030, 60030  # jobtracker
  config.vm.forward_port 50060, 60060  # tasktracker
  config.vm.forward_port 50070, 60070  # namenode
  config.vm.forward_port 50075, 60075  # datanode
end
