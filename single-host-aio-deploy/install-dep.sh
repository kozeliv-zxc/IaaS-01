#!/bin/bash

apt install -y curl \
	sudo \
	bridge-utils \
	git \
	python3-dev \
	libffi-dev \
	gcc \
	libssl-dev \
	libdbus-glib-1-dev \
	python3-venv

python3 -m venv /root/kolla-venv
source /root/kolla-venv/bin/activate
pip install -U pip
pip install git+https://opendev.org/openstack/kolla-ansible@stable/2026.1
mkdir -p /etc/kolla
cp -r /root/kolla-venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
mkdir -p /etc/kolla/ansible/inventory
cp -r /root/kolla-venv/share/kolla-ansible/ansible/inventory/all-in-one /etc/kolla/ansible/inventory
kolla-ansible install-deps
kolla-genpwd

sh ./cinder/install-dep.sh
sh ./octavia/install-dep.sh