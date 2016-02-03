# -*- mode: ruby -*-
# vi: set ft=ruby :


# HACK: ensure we have a local copy of ipxe.iso
hos_url_base = "http://tarballs.gozer.ftclab.gozer.hpcloud.net/hos/hos-2.1/archived_build/"
hos_build = "01-291"
hos_iso_name = "hLinux-cattleprod-amd64-blaster-netinst-20151119-hlm.2015-12-11T07:42:36_8230c52.iso"
hos_iso_url = "#{ hos_url_base }/#{ hos_build }/#{ hos_iso_name }"

system("bash -c '[ ! -f ipxe.iso ] && wget http://boot.ipxe.org/ipxe.iso'")
system("bash -c '[ ! -f #{hos_iso_name} ] && wget #{hos_iso_url}'")

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  config.vm.define "iso-builder-dban" do |iso_builder|
    # this VM is used to build the ISO, when your developing on an OSX machine
    # apply the iso-builder role to create a custom install ISO
    iso_builder.vm.box = "hashicorp/precise64"

    # run the playbook that creates a new ISO
    iso_builder.vm.provision "ansible" do |ansible|
      ansible.sudo = true
      #ansible.verbose = 'vvvv'
      ansible.host_key_checking = false
      ansible.extra_vars = { build_host: "iso_builder_dban", iso_output: "/tmp/Custom.iso" }
      ansible.playbook = "tests/build_iso_dban.yml"
    end

    # retrieve the new ISO file from the VM
    iso_builder.vm.provision :shell, inline: "cp /tmp/Custom.iso /vagrant/Custom.iso"
  end

  config.vm.define "iso-builder-ubuntu" do |iso_builder|
    # this VM is used to build the ISO, when your developing on an OSX machine
    # apply the iso-builder role to create a custom install ISO
    iso_builder.vm.box = "hashicorp/precise64"

    iso_builder.vm.provision :shell, inline: "rm -rf /tmp/Custom.iso /vagrant/Custom.iso"
    iso_builder.vm.provision :shell, inline: "cp /vagrant/ubuntu-14.04.3-server-amd64.iso /tmp/"
    # run the playbook that creates a new ISO
    iso_builder.vm.provision "ansible" do |ansible|
      ansible.sudo = true
      #ansible.verbose = 'vvvv'
      ansible.host_key_checking = false
      ansible.extra_vars = { build_host: "iso-builder-ubuntu", iso_output: "/tmp/Custom.iso" }
      ansible.playbook = "tests/build_iso_ubuntu1404.yml"
    end

    # retrieve the new ISO file from the VM
    iso_builder.vm.provision :shell, inline: "cp /tmp/Custom.iso /vagrant/Custom.iso"
  end

  config.vm.define "iso-builder-hlinux-dhcp" do |iso_builder|
    # this VM is used to build the ISO, when your developing on an OSX machine
    # apply the iso-builder role to create a custom install ISO
    iso_builder.vm.box = "hashicorp/precise64"

    iso_builder.vm.provision :shell, inline: "rm -rf /tmp/Custom.iso /vagrant/Custom.iso"
    iso_builder.vm.provision :shell, inline: "cp /vagrant/#{hos_iso_name} /tmp/"
    # run the playbook that creates a new ISO
    iso_builder.vm.provision "ansible" do |ansible|
      ansible.sudo = true
      #ansible.verbose = 'vvvv'
      ansible.host_key_checking = false
      ansible.extra_vars = {
        iso_distro: "hlinux",
        iso_distro_flavor: "hlinux",
        iso_version: "#{ hos_build }",
        iso_basename: "{{ hos_iso_name|replace('.iso', '') }}",
        iso_url: "#{ hos_iso_url }",

        # Use DHCP to get an address, NB, hLinux then persists
        # this as a static ip address on the interface
        iso_choose_interface: "eth0",
        iso_choose_interface_mac: "08:00:27:08:3F:50",

        build_host: "iso-builder-hlinux-dhcp",
        iso_output: "/tmp/Custom.iso",
        hos_iso_name: "#{hos_iso_name}"
      }
      ansible.playbook = "tests/build_iso_hlinux.yml"
    end

    # retrieve the new ISO file from the VM
    iso_builder.vm.provision :shell, inline: "cp /tmp/Custom.iso /vagrant/Custom.iso"
  end

  config.vm.define "iso-builder-hlinux-static" do |iso_builder|
    # this VM is used to build the ISO, when your developing on an OSX machine
    # apply the iso-builder role to create a custom install ISO
    iso_builder.vm.box = "hashicorp/precise64"

    iso_builder.vm.provision :shell, inline: "rm -rf /tmp/Custom.iso /vagrant/Custom.iso"
    iso_builder.vm.provision :shell, inline: "cp /vagrant/#{hos_iso_name} /tmp/"
    # run the playbook that creates a new ISO
    iso_builder.vm.provision "ansible" do |ansible|
      ansible.sudo = true
      #ansible.verbose = 'vvvv'
      ansible.host_key_checking = false
      ansible.extra_vars = {
        # these match the private_network definition in the "boot-from-iso" vm below
        iso_distro: "hlinux",
        iso_distro_flavor: "hlinux",
        iso_version: "#{ hos_build }",
        iso_basename: "{{ hos_iso_name|replace('.iso', '') }}",
        iso_url: "#{ hos_iso_url }",

        iso_choose_interface: "eth2",
        iso_choose_interface_mac: "08:00:27:5D:6A:02",
        iso_nameserver: "127.0.0.1",
        iso_static_network: true,
        iso_ipaddress: "192.168.12.12",
        iso_netmask: "255.255.255.0",
        iso_gateway: "192.168.12.1",

        build_host: "iso-builder-hlinux-static",
        iso_output: "/tmp/Custom.iso",
        hos_iso_name: "#{hos_iso_name}"
      }
      ansible.playbook = "tests/build_iso_hlinux.yml"
    end

    # retrieve the new ISO file from the VM
    iso_builder.vm.provision :shell, inline: "cp /tmp/Custom.iso /vagrant/Custom.iso"
  end

  # Rebuild an Emulex NIC Firmware ISO for HP BL465 blades
  config.vm.define "iso-builder-oneconnect" do |iso_builder|
    # this VM is used to build the ISO, when your developing on an OSX machine
    # apply the iso-builder role to create a custom install ISO
    iso_builder.vm.box = "hashicorp/precise64"

    iso_builder.vm.provision :shell, inline: "rm -rf /tmp/Custom.iso /vagrant/Custom.iso"
    iso_builder.vm.provision :shell, inline: "cp /vagrant/OneConnect-Flash-4.9.416.0.iso /tmp/"
    # run the playbook that creates a new ISO
    iso_builder.vm.provision "ansible" do |ansible|
      ansible.sudo = true
      #ansible.verbose = 'vvvv'
      ansible.host_key_checking = false
      ansible.extra_vars = {
        iso_distro: "OneConnect",
        iso_distro_flavor: "Flash",
        iso_version: "4.9.416.0",
        iso_basename: "OneConnect-Flash-4.9.416.0",
        iso_url: "http://ftp.hp.com/pub/softlib/software12/COL46628/co-131997-1/OneConnect-Flash-4.9.416.0.iso",

        build_host: "iso-builder-oneconnect",
        iso_output: "/tmp/Custom.iso",
      }
      ansible.playbook = "tests/build_iso_oneconnect.yml"
    end

    # retrieve the new ISO file from the VM
    iso_builder.vm.provision :shell, inline: "cp /tmp/Custom.iso /vagrant/Custom.iso"
  end

  config.vm.define "boot-from-iso" do |iso_boot|
    iso_boot.vm.boot_timeout = 600
    # this VM is a special unprovisioned node that we set to boot from an ISO
    iso_boot.vm.box = "boot-from-iso"
    iso_boot.vm.box_url = "https://www.dropbox.com/s/yum30836kjwgt4w/boot-from-iso.box?dl=1"

    # create a bunch of networks to make it interesting
    iso_boot.vm.network :private_network, :ip => "192.168.11.11", :mac => '08002774EB01'
    iso_boot.vm.network :private_network, :ip => "192.168.12.12", :mac => '0800275D6A02'
    iso_boot.vm.network :private_network, :ip => "192.168.13.13", :mac => '080027844703'

    iso_boot.vm.provider "virtualbox" do |virtualbox|
      # NAT MAC: 080027083F58
      virtualbox.customize ["modifyvm", :id, "--macaddress1", "080027083F00" ]

      virtualbox.gui = true unless ENV['NO_GUI']
      # --boot<1-4> none|floppy|dvd|disk|net>
      virtualbox.customize ["modifyvm", :id, "--boot1", "dvd"]
      # VBoxManage.exe storageattach "<uuid|vmname>" --storagectl IDE --port 0 --device 0 --type dvddrive --medium "X:\Folder\containing\the.iso"
      virtualbox.customize ["storageattach", :id, "--storagectl",
                              "IDE", "--port",  "0", "--device", "0", "--type", "dvddrive",
                              "--medium", "Custom.iso"]

      # disable the guest additions & shared folder checks
      virtualbox.check_guest_additions = false
      virtualbox.functional_vboxsf     = false
    end
  end

end
