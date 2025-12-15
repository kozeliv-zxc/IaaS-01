#!/bin/bash

NET_IF=eth0
NEUTRON_EXT_BRIDGE_IF=br-ex

if ! ip addr show dev $NEUTRON_EXT_BRIDGE_IF | grep -q "172.10.1.1"; then
    ip addr add 172.10.1.1/24 dev $NEUTRON_EXT_BRIDGE_IF
    ip link set dev $NEUTRON_EXT_BRIDGE_IF up
    echo "[local-setup] Assigned IP to $NEUTRON_EXT_BRIDGE_IF"
fi

# Clean up existing NAT and FORWARD rules (ignore errors)
iptables -t nat -D POSTROUTING -s 172.10.1.0/24 -o $NET_IF -j MASQUERADE 2>/dev/null || true
iptables -D FORWARD -i $NEUTRON_EXT_BRIDGE_IF -o $NET_IF -j ACCEPT 2>/dev/null || true
iptables -D FORWARD -i $NET_IF -o $NEUTRON_EXT_BRIDGE_IF -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true

# Reapply NAT and forwarding rules for traffic from VMs to the internet
iptables -t nat -A POSTROUTING -s 172.10.1.0/24 -o $NET_IF -j MASQUERADE
iptables -A FORWARD -i $NEUTRON_EXT_BRIDGE_IF -o $NET_IF -j ACCEPT
iptables -A FORWARD -i $NET_IF -o $NEUTRON_EXT_BRIDGE_IF -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "[local-setup] NAT + FORWARDING rules set for $NEUTRON_EXT_BRIDGE_IF ↔ $NET_IF"

# Ensure route to floating IP subnet via $NEUTRON_EXT_BRIDGE_IF
if ! ip route show 172.10.1.0/24 | grep -q "$NEUTRON_EXT_BRIDGE_IF"; then
    ip route add 172.10.1.0/24 dev $NEUTRON_EXT_BRIDGE_IF
    echo "[local-setup] Added route for 172.10.1.0/24 via $NEUTRON_EXT_BRIDGE_IF"
fi

echo "[local-setup] Completed $NEUTRON_EXT_BRIDGE_IF setup"