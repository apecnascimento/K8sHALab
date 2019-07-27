Vagrant.configure("2") do |config|
    (1..4).each do |i|
        config.vm.define "m-#{i}" do |machine|
            machine.vm.box = "bento/ubuntu-16.04"
            machine.vm.hostname = "m-#{i}"
            machine.vm.box_url = "bento/ubuntu-16.04"
            
            machine.vm.network :private_network, ip: "192.168.56.10#{i}"
        
            machine.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                v.customize ["modifyvm", :id, "--memory", 1024]
                v.customize ["modifyvm", :id, "--name", "m-#{i}"]
            end
        end
    end
end