user = $(whoami)

deps-config:
	sudo dnf install git python3-devel libffi-devel gcc openssl-devel python3-libselinux -y
	python3 -m venv /home/$(user)/deploy
	source /home/$(user)/deploy/bin/activate && python3 -m pip install -U pip
	source /home/$(user)/deploy/bin/activate && python3 -m pip install 'ansible-core>=2.16,<2.17.99'
	source /home/$(user)/deploy/bin/activate && python3 -m pip install git+https://opendev.org/openstack/kolla-ansible@stable/2024.2
	sudo mkdir -p /etc/kolla
	sudo chown $(user):$(user) /etc/kolla
	cp -r /home/$(user)/deploy/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
	cp -r /path/to/venv/share/kolla-ansible/ansible /etc/kolla
	source /home/$(user)/deploy/bin/activate && kolla-ansible install-deps
	source /home/$(user)/deploy/bin/activate && kolla-genpwd