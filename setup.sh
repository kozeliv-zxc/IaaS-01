#!/bin/sh

user = $(whoami)
apt = $(which apt)
dnf = $(which dnf)

if [ $user != "root" ]; then
    echo "must be root"
    exit 1
fi

if [ $apt ]; then
    apt install git python3-dev python3-pip libffi-dev gcc libssl-dev python3-venv -y
elif [ $dnf ]; then
    dnf install git python3-devel libffi-devel gcc openssl-devel python3-libselinux -y
else
    echo "what the..."
fi