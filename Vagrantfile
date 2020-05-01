require 'yaml'

# get details of boxes to build
boxes = YAML.load_file('./boxes.yaml')

# API version
PROJECT_NAME = '/vagrant/' + File.basename(Dir.getwd)
DEFAULT_BASE_BOX = 'debian/buster64'

Vagrant.configure(2) do |config|
  boxes.each do |boxes|
    config.vm.define boxes['name'] do |srv|
      # OS and hostname
      srv.vm.box = boxes['box'] ||= DEFAULT_BASE_BOX
      srv.vm.hostname = boxes['name']

      srv.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--cpus', boxes['cpus']] if boxes.key? 'cpus'
        vb.customize ['modifyvm', :id, '--memory', boxes['ram']] if boxes.key? 'memory'
        vb.customize ['modifyvm', :id, '--name', boxes['name']] if boxes.key? 'name'
        vb.customize ['modifyvm', :id, '--description', boxes['description']] if boxes.key? 'description'
        vb.customize ['modifyvm', :id, '--groups', PROJECT_NAME]
      end

      # Copy cloud-init files to tmp and provision
      if boxes['provision']
        srv.vm.provision :file, :source => boxes['provision']['meta-data'], :destination => '/tmp/vagrant/cloud-init/nocloud-net/meta-data'
        srv.vm.provision :file, :source => boxes['provision']['user-data'], :destination => '/tmp/vagrant/cloud-init/nocloud-net/user-data'
        srv.vm.provision :shell, :path => boxes['provision']['cloud-init'], :args => boxes['name']
      end
    end
  end
end
