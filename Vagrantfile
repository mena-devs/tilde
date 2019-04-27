# -*- mode: ruby -*-
# vi: set ft=ruby :

require "open-uri"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.network "forwarded_port", guest: 3000,  host: 3000, auto_correct: true
  config.vm.network "forwarded_port", guest: 5432,  host: 5432, auto_correct: true
  config.vm.network "forwarded_port", guest: 22,  host: 22, auto_correct: true
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "tilde"
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.define :tilde do |tilde|
  end

  vagrantkey = open("https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub", "r", &:read)

  config.vm.provision :shell,
                       inline: <<-INLINE
      install -d -m 700 /root/.ssh
      echo -e "#{vagrantkey}" > /root/.ssh/authorized_keys
      chmod 0600 /root/.ssh/authorized_keys
  INLINE

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible-rails/site.yml"
  end
end
