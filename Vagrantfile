# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  box = "centos/7"

	#Setup hostmanager config to update the host files
	config.hostmanager.enabled = true
  	config.hostmanager.manage_host = true
  	config.hostmanager.ignore_private_ip = false
  	config.hostmanager.include_offline = true
  	config.vm.provision :hostmanager

	config.vm.define :central do |central_config|
		central_config.vm.box = box
		central_config.vm.hostname = "central.local"
		central_config.vm.network "private_network", ip: "10.0.0.10"
	    central_config.vm.network :forwarded_port, guest: 5672, host: 5672, auto_correct: true
    	central_config.vm.network :forwarded_port, guest: 15672, host: 15672, auto_correct: true
    	central_config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true

		central_config.vm.provision "shell", inline: <<-END
			# To use local ansible it needs to install pip
			yum install -y epel-release
		  	yum install -y python2-pip python-devel
		  	pip install --upgrade pip
		  	pip install ansible
		END

		vm.provision "shell",
			inline: "sudo ifup eth1"

		central_config.vm.provision "ansible_local" do |ansible|
			ansible.playbook = "central.yml"
		end
	end

	config.vm.define :worker do |worker_config|
		worker_config.vm.box = box
		worker_config.vm.hostname = "worker.local"
		worker_config.vm.network "private_network", ip: "10.0.0.11"

        vm.provision "shell",
            inline: "sudo ifup eth1"

        worker_config.vm.provision "ansible_local" do |ansible|
            ansible.playbook = "worker.yml"
        end

	end
end
