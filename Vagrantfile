# -*- mode: ruby -*-
# # vi: set ft=ruby :
#

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    
    config.vm.provider :virtualbox do |vb|
        vb.customize [
            "modifyvm", :id,
            "--memory", "2048"
        ]
    end

    # Forward port
    config.vm.network "forwarded_port", guest:5432, host:15432

    # Provision the box
    config.vm.provision "shell", path: "bootstrap.sh"
end
