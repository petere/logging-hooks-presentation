# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise"

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file = "default.pp"
    puppet.module_path = "modules"
  end
end
