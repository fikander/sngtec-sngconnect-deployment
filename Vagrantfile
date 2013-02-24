Vagrant::Config.run do |config|

    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.provision :shell, :inline => "sudo /usr/bin/apt-get -qq update && sudo /usr/bin/apt-get -qq -y install puppet-common"
    #config.vm.provision :puppet, :options => "--verbose --debug" do |puppet|
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "site.pp"
        puppet.module_path    = [
            "puppet/services",
            "puppet/modules",
        ]
    end

    config.vm.define :mon do |subconfig|
        subconfig.vm.host_name = "dev-mon"
        subconfig.vm.customize [
            "modifyvm", :id,
            "--memory", "256",
        ]
        subconfig.vm.network :hostonly, "192.168.50.5"
        subconfig.vm.forward_port 80, 9080
    end

    config.vm.define :app1 do |subconfig|
        subconfig.vm.host_name = "dev-app-1"
        subconfig.vm.customize [
            "modifyvm", :id,
            "--memory", "256",
        ]
        subconfig.vm.network :hostonly, "192.168.50.2"
        subconfig.vm.forward_port 80, 8080
    end

    config.vm.define :db1 do |subconfig|
        subconfig.vm.host_name = "dev-db-1"
        subconfig.vm.customize [
            "modifyvm", :id,
            "--memory", "512",
        ]
        subconfig.vm.network :hostonly, "192.168.50.3"
    end

    config.vm.define :cass1 do |subconfig|
        subconfig.vm.host_name = "dev-cass-1"
        subconfig.vm.customize [
            "modifyvm", :id,
            "--memory", "2048",
            "--cpus", "2",
            "--cpuexecutioncap", "100"
        ]
        subconfig.vm.network :hostonly, "192.168.50.4"
    end

end
