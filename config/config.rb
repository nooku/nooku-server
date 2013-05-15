require 'erb'
require 'ostruct'
require 'yaml'

module NookuServer
  class Config
    def initialize(file)
      @file = File.expand_path(File.join(File.dirname(__FILE__), file))
    end

    def parse
      @data = {}

      if File.exists?(@file)
        @data.merge!(YAML.load_file(@file))

        @data.each do |host, settings|
          settings['dir'] = File.expand_path(settings['dir'])
        end
      end
    end

    def create_nodes
      # Remove content of nodes directory.
      dir_path = File.expand_path(File.join(File.dirname(__FILE__), '../puppet/manifests/nodes'))
      Dir.foreach(dir_path) { |f| fn = File.join(dir_path, f); File.delete(fn) if f.chars.first != '.' }

      hosts = {}
      data.each do |host, settings|
        hosts[host] = {}
        hosts[host][:public_dir] = (File.directory?(File.expand_path(File.join(settings['dir'], 'code')))) ? '/code' : '/'
        hosts[host][:sql]  = settings['sql'] if settings.has_key?('sql')
        hosts[host][:less] = settings['less'] if settings.has_key?('less')
      end

      # Create node from node.erb.
      node = File.expand_path(File.join(File.dirname(__FILE__), 'templates/node.erb'))

      namespace = OpenStruct.new({ :hosts => hosts })
      File.open(File.expand_path(File.join(dir_path, 'nooku.vagrant.pp')), 'w') do |f|
        f.write ERB.new(File.read(node), nil, '-').result(namespace.instance_eval { binding })
      end
    end

    def data
      @data ||= parse
    end

    def synced_folders
      folders = []

      data.each do |host, settings|
        folders << {:name => host, :path => settings['dir']}
      end
      folders
    end
  end
end