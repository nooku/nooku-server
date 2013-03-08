require File.expand_path(File.join(File.dirname(__FILE__), 'config/config.rb'))

Vagrant::Config.run do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.host_name = 'nooku.dev'
  config.vm.network :hostonly, '192.168.50.10'
  config.vm.customize ['modifyvm', :id, '--name', 'Nooku Development']
  config.vm.customize ['modifyvm', :id, '--memory', 512]

  config_file = NookuServer::Config.new('config.yaml')
  config_file.create_nodes

  config_file.share_folders.each do |folder|
    config.vm.share_folder folder[:name], "/var/www/#{folder[:name]}/source", folder[:path], :nfs => true
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'init.pp'
    puppet.module_path = 'puppet/modules'

    # Uncomment these lines if you have issues.
    #puppet.options = [
    #  '--verbose',
    #  '--debug',
    #]
  end
end