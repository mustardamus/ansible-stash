env=staging
PRODUCTION_SERVER_IP=`awk -F= '{ print $$2 }' inventories/production/hosts.ini | xargs`

install:
	bash install_ansible.sh
	sudo ansible-playbook -i inventories/localhost/hosts.ini _devenv.yml

staging_up:
	vagrant up

staging_halt:
	vagrant halt

staging_destroy:
	vagrant destroy

check_env:
ifeq ($(env), staging)
	$(info running "staging" environment...)
else ifeq ($(env), production)
	$(info running "production" environment...)
else
	$(error "env" must be "staging" or "production")
endif

init: check_env
ifeq ($(env), staging)
	ssh-keygen -f ~/.ssh/known_hosts -R [127.0.0.1]:22522
	vagrant up
else ifeq ($(env), production)
	bash init_production.sh
endif

ssh: check_env
ifeq ($(env), staging)
	ssh ansible@127.0.0.1 -p 22522
else ifeq ($(env), production)
	ssh ansible@$(PRODUCTION_SERVER_IP)
endif

deploy: check_env
ifdef version
	ansible-playbook -i inventories/$(env)/hosts.ini -e env=$(env) -e version=$(version) _deploy.yml
else
	$(error "version" variable must be set)
endif

rollback:
	ansible-playbook -i inventories/$(env)/hosts.ini -e env=$(env) -e rollback=true _deploy.yml

email: check_env
	ansible-playbook -i inventories/$(env)/hosts.ini -e env=$(env) _email.yml

chat: check_env
	ansible-playbook -i inventories/$(env)/hosts.ini -e env=$(env) _chat.yml

git: check_env
	ansible-playbook -i inventories/$(env)/hosts.ini -e env=$(env) _git.yml

dihr: check_env
ifdef version
	ansible-playbook -i inventories/$(env)/hosts.ini -e env=$(env) -e version=$(version) _darfichheuteraus.yml
else
	$(error "version" variable must be set)
endif