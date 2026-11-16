Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-12"
  config.vm.hostname = "lab-debian"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.provider "vmware_desktop" do |vmware|
    vmware.linked_clone = false
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/provision.yml"
  end
end