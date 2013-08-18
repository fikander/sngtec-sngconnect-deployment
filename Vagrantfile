# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.provision :shell, :inline => "dpkg-query -W puppet-common >/dev/null || sudo /usr/bin/apt-get -qq update && sudo /usr/bin/apt-get -qq -y install puppet-common"
    #config.vm.provision :puppet, :options => "--verbose --debug" do |puppet|
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "development.pp"
        puppet.module_path    = [
            "puppet/services",
            "puppet/modules",
        ]
    end

    config.vm.define :mon do |subconfig|
        subconfig.vm.hostname = "dev-mon"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize [
                "modifyvm", :id,
                "--memory", "1024",
            ]
        end
        subconfig.vm.network :private_network, ip: "192.168.50.2"
        subconfig.vm.network :forwarded_port, guest: 80, host: 9080
    end

    config.vm.define :app1 do |subconfig|
        subconfig.vm.hostname = "dev-app-1"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize [
                "modifyvm", :id,
                "--memory", "256",
            ]
        end
        subconfig.vm.network :private_network, ip: "192.168.50.3"
        subconfig.vm.network :forwarded_port, guest: 80, host: 8080
    end

    config.vm.define :db1 do |subconfig|
        subconfig.vm.hostname = "dev-db-1"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize [
                "modifyvm", :id,
                "--memory", "512",
            ]
        end
        subconfig.vm.network :private_network, ip: "192.168.50.4"
    end

    config.vm.define :cass1 do |subconfig|
        subconfig.vm.hostname = "dev-cass-1"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize [
                "modifyvm", :id,
                "--memory", "2048",
                "--cpus", "2",
                "--cpuexecutioncap", "100"
            ]
        end
        subconfig.vm.network :private_network, ip: "192.168.50.5"
    end

end
