#!/bin/bash

if ! ip addr show dev br-ex | grep -q "172.10.1.1"; then
    ip addr add 172.10.1.1/24 dev br-ex
    ip link set dev br-ex up
    echo "[local-setup] Assigned IP to br-ex"
fi

# Clean up existing NAT and FORWARD rules (ignore errors)
iptables -t nat -D POSTROUTING -s 172.10.1.0/24 -o eth0 -j MASQUERADE 2>/dev/null || true
iptables -D FORWARD -i br-ex -o eth0 -j ACCEPT 2>/dev/null || true
iptables -D FORWARD -i eth0 -o br-ex -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true

# Reapply NAT and forwarding rules for traffic from VMs to the internet
iptables -t nat -A POSTROUTING -s 172.10.1.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i br-ex -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o br-ex -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "[local-setup] NAT + FORWARDING rules set for br-ex ↔ eth0"

# Ensure route to floating IP subnet via br-ex
if ! ip route show 172.10.1.0/24 | grep -q "br-ex"; then
    ip route add 172.10.1.0/24 dev br-ex
    echo "[local-setup] Added route for 172.10.1.0/24 via br-ex"
fi

echo "[local-setup] Completed br-ex setup"