Vagrant.configure("2") do |config|
  config.vm.define "badass" do |badass|
    badass.vm.box = "debian/bullseye64"
    badass.vm.network "private_network", ip: "192.168.56.42"
    badass.vm.synced_folder ".", "/badass"
    badass.vm.provision "Provisioning script", type: "shell", path: "./.scripts/provision.sh"
    badass.vm.hostname = "badass"
    badass.vm.provider "virtualbox" do |vb|
      vb.name = "badass"
      vb.memory = 2048
      vb.cpus = 2
      vb.gui = true
      vb.customize ["modifyvm", :id, "--vram", "128"]
      end
  end
end
