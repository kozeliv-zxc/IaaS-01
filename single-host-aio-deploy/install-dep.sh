#!/bin/sh

apt install -y bridge-utils

sh ./cinder/install-dep.sh
sh ./octavia/install-dep.sh