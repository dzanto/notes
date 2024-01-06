---
title: "Установка k8s с kubeadm"
date: 2023-07-05T12:08:00+03:00
draft: false
tags: [k8s]
---
sudo dnf install vagrant

```ruby
Vagrant.configure("2") do |config|
    # hosts = ["master", "worker"]
    (1..2).each do |i|
        config.vm.define "node-#{i}" do |host|
            host.vm.box = "oraclelinux/8"
            host.vm.box_url = "https://oracle.github.io/vagrant-projects/boxes/oraclelinux/8.json"
            host.vm.network "public_network", ip: "192.168.1.1#{i}", bridge: "wlp0s20f3"
            host.vm.hostname = "node#{i}"
            host.vm.provider "virtualbox" do |vb|
                vb.memory = 4096
                vb.cpus = 2
            end
            host.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
            host.vm.provision "shell", inline: <<-SHELL
            sudo cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
            SHELL
        end
    end
end
```