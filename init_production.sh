#!/bin/bash

HOSTS_PATH=inventories/production/hosts.ini

if [ -d "inventories/production" ]; then
  # TODO check if there is still "example.com" in the vars and exit
  PRODUCTION_SERVER_IP=`awk -F= '{ print $2 }' $HOSTS_PATH | xargs`
  ANSIBLE_HOST_KEY_CHECKING=false

	ssh-keyscan -H $PRODUCTION_SERVER_IP >> ~/.ssh/known_hosts
	ansible-playbook --ask-pass -i $HOSTS_PATH _init.yml
else
  echo ""
  read -p "Production Server IP: " PRODUCTION_SERVER_IP

  mkdir -p inventories/production/group_vars
  cp inventories/staging/group_vars/all.yml inventories/production/group_vars/all.yml

  echo "[servers]
server1 ansible_host=$PRODUCTION_SERVER_IP" > $HOSTS_PATH

  echo "Edit the variables in 'inventories/production/group_vars/all.yml' and re-run the command."
fi
