# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'trusty64'
  config.vm.box_url = 'https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box'
  ## Cannot build necessary gems without 3GB+ of ram.
  config.vm.provider 'virtualbox' do |v|
    v.memory = 4096
    v.cpus = 2
  end

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  Vagrant.has_plugin?('vagrant-berkshelf') ? config.berkshelf.enabled = true : ''

  config.vm.define 'souschef' do |box1|
    box1.vm.hostname = 'souschef'
    box1.vm.network :private_network, ip: '192.168.24.122'
    Vagrant.has_plugin?('vagrant-hostmanager') ? box1.hostmanager.aliases = %w(server alias) : ''
    box1.omnibus.chef_version = '11.16.4'

    box1.vm.provision 'chef_solo' do |chef|
      chef.cookbooks_path = './cookbooks'
      chef.roles_path = './roles'
      chef.json = {}
      chef.add_role 'test_role'
    end
  end
end
