Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |jenkins|
   jenkins.vm.box = "hashicorp/bionic64"
   jenkins.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
   jenkins.vm.network "private_network", ip: "192.168.33.10"
   jenkins.vm.synced_folder ".", "/vagrant", type: "virtualbox"
   jenkins.vm.provision :shell, path: "bootstrap.sh"
   end
 
  config.vm.define "web" do |web|
  web.vm.box = "hashicorp/bionic64"
  web.vm.network "private_network", ip: "192.168.33.11"  
  web.vm.network "forwarded_port", guest: 80, host: 8081, host_ip: "127.0.0.1"
  web.vm.provision :shell, path: "nginx.sh"
  end
end
