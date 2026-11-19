Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-12"
  config.vm.hostname = "ssh-lab"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider "vmware_desktop" do |vmware|
    vmware.linked_clone = false
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/provision.yml"
  end
end