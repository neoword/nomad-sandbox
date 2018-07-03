# -*- mode: ruby -*-
# vi: set ft=ruby :

NUM_NODES=4

# setup ip addresses
NET_PREFIX = "192.168.33."
NODES = {}
hosts = ""
(1..NUM_NODES).each do |i|
  ip = NET_PREFIX + (9+i).to_s
  NODES["node#{i}"] = ip
  hosts += ip + " " + "node#{i}" + "\\\n"
end

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04" # 16.04 LTS
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.linked_clone = true
  end

  (1..NUM_NODES).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}"
        node.vm.provider "virtualbox" do |vb|
        vb.name = "nomad_node#{i}"
      end
      ip = "#{NODES[node.vm.hostname]}"
      # setup private network
      node.vm.network :private_network, ip: "#{ip}", virtualbox__intnet: true
      node.vm.network "forwarded_port", guest: 4646, guest_ip: "#{ip}", host: 4646, auto_correct: true
      node.vm.provision "shell", path: "scripts/provision.sh", privileged: false, args: "#{ip}"
      node.vm.provision "shell", path: "scripts/update_hosts.sh", privileged: false, args: "#{node.vm.hostname} '#{hosts}'"
      if i==1 # server
        node.vm.provision "shell", path: "scripts/server.sh", privileged: false, args: "#{ip}"
      else # client
        node.vm.provision "shell", path: "scripts/client.sh", privileged: false, args: "#{ip}"
      end
      node.vm.provision "docker" # Just install it
    end
  end

end
