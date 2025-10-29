SHELL := /bin/bash
user = $(shell whoami)
apt := $(shell which apt)
dnf := $(shell which dnf)

install-deps:
ifdef $(dnf)
	sudo dnf install git python3-devel libffi-devel gcc openssl-devel python3-libselinux -y
else
	ifdef $(apt)
		sudo apt install git python3-dev python3-pip libffi-dev gcc libssl-dev python3-venv -y
	else
		print "what the ...?"
	endif
endif

init:
	python3 -m venv /home/$(user)/deploy
	sh /home/$(user)/deploy/bin/activate && python3 -m pip install -U pip
	sh /home/$(user)/deploy/bin/activate && python3 -m pip install 'ansible-core>=2.16,<2.17.99'
	sh /home/$(user)/deploy/bin/activate && python3 -m pip install git+https://opendev.org/openstack/kolla-ansible@stable/2024.2
	sudo mkdir -p /etc/kolla
	sudo chown $(user):$(user) /etc/kolla
	cp -r /home/$(user)/deploy/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
	cp -r /home/$(user)/deploy/share/kolla-ansible/ansible /etc/kolla
	sh /home/$(user)/deploy/bin/activate && kolla-ansible install-deps
	sh /home/$(user)/deploy/bin/activate && kolla-genpwd