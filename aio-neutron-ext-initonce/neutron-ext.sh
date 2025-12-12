#!/bin/bash

ip link add name veth-ext type veth peer name veth-peer

ip link set veth-ext up
ip link set veth-peer up

ip link set veth-ext master br-exnat

ip route add 172.10.1.0/24 dev br-exnat

ip link set br-exnat up