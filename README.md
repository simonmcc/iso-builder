iso-builder
=========

Manipulate an existing Ubuntu or hLinux ISO so that it's a zero-touch installation ISO image, including the creation accounts, disk layout & static network configuration.

For Ubuntu both the preseed and the kickstart file are configurable, for Debian/hLinux the preseed file is templated.

debian-installer preseed notes:
* https://www.debian.org/releases/wheezy/i386/apbs02.html.en
* https://www.debian.org/releases/wheezy/i386/apbs03.html.en
* https://www.debian.org/releases/stable/example-preseed.txt

Requirements
------------

An Debian/Ubuntu host to mount & manipulate the existing ISO - the bundled Vagrantfile has a iso-builder host that allows you to build ISO images on non-Linux hosts.  The boot-from-iso vagrant host is also setup to use the default Custom.iso that will be built.

Role Variables
--------------

	iso_distro: "ubuntu"
	iso_distro_flavor: "server"
	iso_version: "14.04"
	iso_release: ".3"
	iso_flavor: "server"
	iso_arch: "amd64"
	iso_urlbase: "http://releases.ubuntu.com/"
	iso_basename: "{{ iso_distro }}-{{ iso_version }}{{ iso_release }}-{{ iso_flavor }}-{{ iso_arch }}"
	iso_name: "{{ iso_basename }}.iso"
	iso_url: "{{ iso_urlbase }}/{{ iso_version }}/{{ iso_name }}"
	
	workdir: /tmp
	mounted_iso: "{{ workdir }}/mounted_{{ iso_basename }}/"
	new_iso: "{{ workdir }}/new_{{ iso_basename }}_iso/"

See [defaults/main.yml](defaults/main.yml) for further examples of use with Ubuntu Server 14.04.3 & hLinux 01-399.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
	
	---
	- name: Build Custom ISO
	  hosts: all
	  gather_facts: false
	  sudo: true
	
	  vars:
	    iso_distro: hlinux
	    iso_version: "01-399"
	    iso_distro_flavor: hlinux
	    # TODO: find a way to handle the nasty file names used by the gozer generated ISO
	    iso_basename: "hos2.0-build01-399"
	    iso_url: "http://tarballs.gozer.ftclab.gozer.hpcloud.net/hos/hos-2.0.0/archived_build/01-399/{{ iso_basename }}.iso"
	
	  roles:
	    - { role: iso-builder }

Vagrant Workflow
----------------
There is a top-level Vagrantfile that wraps most of the build & test phase, this is currently optimised for use under OSX, on a linux workstation you could avoid using a VM to do the ISO extract & rebuild.

License
-------

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.

See the License for the specific language governing permissions and
limitations under the License.

Author Information
------------------

Simon McCartney simon.mccartney@hpe.com