#!/bin/bash

python3 -m venv dib-venv
source ./dib-venv/bin/activate
pip install diskimage-builder
git clone https://opendev.org/openstack/octavia
pushd ./octavia/diskimage-create
git checkout stable/2026.1
source ./diskimage-create.sh