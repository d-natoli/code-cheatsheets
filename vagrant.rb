---------------
Create a new VM
---------------
vagrant init <name>
vagrant up
vagrant ssh <name>

------------------------
Create a custom base box
------------------------
vagrant package
vagrant box add <box_name> package.box

----------------------------
Vagrantfile for multiple vms
----------------------------
Vagrant::Config.run do |config|
  config.vm.define :app do |app_config|
    app_config.vm.customize ["modifyvm", :id, "--name", "app", "--memory", "512"]
    app_config.vm.box = "lucid64_with_ruby193"
    app_config.vm.host_name = "app"
    app_config.vm.forward_port 22, 2222, :auto => true
    app_config.vm.forward_port 80, 4567
    app_config.vm.network :hostonly, "33.33.13.37"
  end

  config.vm.define :db do |db_config|
    db_config.vm.customize ["modifyvm", :id, "--name", "db", "--memory", "512"]
    db_config.vm.box = "lucid64_with_ruby193"
    db_config.vm.host_name = "db"
    db_config.vm.forward_port 22, 2222, :auto => true
    db_config.vm.network :hostonly, "33.33.13.38"
  end
end
