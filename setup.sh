#!/bin/sh

user="$(whoami)"
apt="$(which apt)"
dnf="$(which dnf)"

if [[ $user != "root" ]]; then
    echo "must be root"
    exit 1
fi

if [ $dnf ]; then
    dnf install -y git python3-devel libffi-devel gcc openssl-devel python3-libselinux
elif [ $apt ]; then
    apt install -y git python3-dev python3-pip libffi-dev gcc libssl-dev python3-venv
else
    echo "what the..."
fi

if [ $user -eq "root" ]; then
    user_path="/root"
else
    user_path="/home/$user"
fi

python3 -m venv $user_path/deploy
. $user_path/deploy/bin/activate
python3 -m pip install -U pip
python3 -m pip install 'ansible-core>=2.16,<2.17.99'
python3 -m pip install git+https://opendev.org/openstack/kolla-ansible@stable/2024.2
mkdir -p /etc/kolla
chown $(user):$(user) /etc/kolla
cp -r $user_path/deploy/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp -r $user_path/deploy/share/kolla-ansible/ansible /etc/kolla
kolla-ansible install-deps
kolla-genpwd