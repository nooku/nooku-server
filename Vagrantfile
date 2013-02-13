# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.host_name = 'nooku.dev'
  config.vm.network :hostonly, '192.168.50.10'
  config.vm.customize ['modifyvm', :id, '--name', 'Nooku Development']
  config.vm.customize ['modifyvm', :id, '--memory', 512]

  config.vm.share_folder 'source', '/var/www/nooku-server/source', '../..'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'init.pp'
    puppet.module_path = 'puppet/modules'
    puppet.options = [
      '--verbose',
      '--debug'
    ]
  end
end