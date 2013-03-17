require File.expand_path(File.join(File.dirname(__FILE__), 'config/config.rb'))

Vagrant.configure('2') do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.hostname = 'nooku.dev'
  config.vm.network :private_network, ip: '192.168.50.10'

  config.vm.provider :virtualbox do |v|
    v.customize ['modifyvm', :id, '--name', 'Nooku Development']
    v.customize ['modifyvm', :id, '--memory', 512]
  end

  config_file = NookuServer::Config.new('config.yaml')
  config_file.create_nodes

  config_file.synced_folders.each do |folder|
    config.vm.synced_folder folder[:path], "/var/www/#{folder[:name]}/source", :nfs => true
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'init.pp'
    puppet.module_path = 'puppet/modules'

    # Uncomment this lines if you have issues.
    #puppet.options = [ '--verbose', '--debug' ]
  end
end