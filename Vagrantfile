Vagrant.configure("2") do |config|

    $loadbalancer_install = <<-SCRIPT
    echo "worker_processes 4;
    worker_rlimit_nofile 40000;
    
    events {
        worker_connections 8192;
    }
    
    stream {
        upstream rancher_servers_http {
            least_conn;
            server 192.168.56.102:80 max_fails=3 fail_timeout=5s;
            server 192.168.56.103:80 max_fails=3 fail_timeout=5s;
            server 192.168.56.104:80 max_fails=3 fail_timeout=5s;
        }
        server {
            listen     80;
            proxy_pass rancher_servers_http;
        }
    
        upstream rancher_servers_https {
            least_conn;
            server 192.168.56.102:443 max_fails=3 fail_timeout=5s;
            server 192.168.56.103:443 max_fails=3 fail_timeout=5s;
            server 192.168.56.104:443 max_fails=3 fail_timeout=5s;
        }
        server {
            listen     443;
            proxy_pass rancher_servers_https;
        }
    
    }" > /etc/nginx.conf
    sudo docker run --name cluster_lb -d --restart=unless-stopped -p 80:80 -p 443:443  -v /etc/nginx.conf:/etc/nginx/nginx.conf nginx:alpine
    SCRIPT

    $docker_install = <<-SCRIPT
    sudo apt-get remove -y docker docker-engine docker.io containerd runc 
    sudo apt-get update
    sudo apt-get install \
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
    sudo apt-get install -y docker docker-compose
    sudo sysctl net.bridge.bridge-nf-call-iptables=1
    sudo usermod -aG docker vagrant 
    SCRIPT


    config.vm.provision: "shell", inline: $docker_install
    config.vm.provision: "shell", inline: $loadbalancer_install
    config.vm.define "LoadBalancer" do |machine|
        machine.vm.box = "bento/ubuntu-16.04"
        machine.vm.hostname = "LoadBalancer"
        machine.vm.box_url = "bento/ubuntu-16.04"
        
        machine.vm.network :private_network, ip: "192.168.56.101"
    
        machine.vm.provider :virtualbox do |v|
            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            v.customize ["modifyvm", :id, "--memory", 1024]
            v.customize ["modifyvm", :id, "--name", "LoadBalancer"]
        end
    end


    (2..4).each do |i|
        config.vm.provision: "shell", inline: $docker_install
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