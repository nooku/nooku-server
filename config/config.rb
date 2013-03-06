require 'yaml'
require 'erb'
require 'ostruct'

module NookuServer
  class Config
    def initialize(file)
      @file = File.expand_path(File.join(File.dirname(__FILE__), file))
    end

    def parse
      @data = {}

      if File.exists?(@file)
        @data.merge!(YAML.load_file(@file))
      end
    end

    def create_nodes
      # Remove content of nodes directory.
      dir_path = File.expand_path(File.join(File.dirname(__FILE__), '../puppet/manifests/nodes'))
      Dir.foreach(dir_path) { |f| fn = File.join(dir_path, f); File.delete(fn) if f.chars.first != '.' }

      # Create nodes from node.erb.
      node = File.expand_path(File.join(File.dirname(__FILE__), 'templates/node.erb'))

      nginx['hosts'].each do |host|
        namespace = OpenStruct.new({:name => host['name'], :public_dir => host['public_dir']})
        File.open(File.join(dir_path, File.basename(host['name'], File.extname(host['name'])) << '.pp'), 'w') do |f|
          f.write ERB.new(File.read(node)).result(namespace.instance_eval { binding })
        end
      end if nginx.has_key?('hosts')
    end

    def data
      @data ||= parse
    end

    def nginx
      data.has_key?('nginx') ? data['nginx'] : {}
    end

    def share_folders
      folders = []

      nginx['hosts'].each do |host|
        folders << {:name => host['name'], :path => File.expand_path(host['local_dir'])}
      end if nginx.has_key?('hosts')
      folders
    end
  end
end