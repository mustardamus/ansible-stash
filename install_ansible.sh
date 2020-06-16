#!/bin/bash

if which ansible >/dev/null; then
  exit 0
fi

DISTRIBUTION="$(awk -F= '$1=="ID" { print $2 }' /etc/os-release)"

if [ $DISTRIBUTION = "debian" ]
then
	echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/ansible.list
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
	sudo apt update
	sudo apt install ansible -y
fi

if [ $DISTRIBUTION = "ubuntu" ]
then
	sudo apt update
  sudo apt install software-properties-common
  sudo apt-add-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible -y
fi
