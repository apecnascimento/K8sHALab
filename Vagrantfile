Vagrant.configure("2") do |config|

    $docker_install = <<-SCRIPT
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"   
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo sysctl net.bridge.bridge-nf-call-iptables=1
    sudo usermod -aG docker vagrant
    SCRIPT

    $rancher_install = <<-SCRIPT
    docker run -d --restart=unless-stopped \
        -p 80:80 -p 443:443 \
        -v /opt/rancher:/var/lib/rancher \
        rancher/rancher:latest
    SCRIPT


    config.vm.provision "shell", inline: $docker_install
    (1..2).each do |i|
        config.vm.define "m-#{i}" do |machine|
            if i == 1
                machine.vm.provision "shell", inline: $rancher_install
            end
            machine.vm.box = "bento/ubuntu-18.04"
            machine.vm.hostname = "m-#{i}"
            machine.vm.box_url = "bento/ubuntu-18.04"            
            
            machine.vm.network :private_network, ip: "192.168.56.10#{i}"
        
            machine.vm.provider :virtualbox do |v|
                v.customize ['modifyvm', :id, '--macaddress1', "08002700005#{i}"]
                v.customize ['modifyvm', :id, '--natnet1', "10.0.5#{i}.0/24"]
                v.customize ["modifyvm", :id, "--memory", 1024]
                v.customize ["modifyvm", :id, "--name", "m-#{i}"]
            end
        end
    end
end