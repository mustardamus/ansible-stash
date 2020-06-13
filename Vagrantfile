Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_url = "https://app.vagrantup.com/ubuntu/boxes/bionic64"

  config.disksize.size = "25GB"

  config.vm.network "forwarded_port", id: "ssh", guest: 22, host: 22522
  config.vm.network "forwarded_port", id: "http", guest: 80, host: 8080
  config.vm.network "forwarded_port", id: "https", guest: 443, host: 8081

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "_init.yml"
  end
end
