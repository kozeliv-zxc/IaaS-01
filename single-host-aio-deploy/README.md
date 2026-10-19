# noticable configuration files

vars.yaml

```
neutron_external_interface: "<secondary interface name>"

if you have one spare network interface, or

neutron_external_interface: "br-exnat-veth-peer"

after setting a pseudo-one

...

kolla_internal_vip_address: "<your network unused IP>"

act as a stable API for multiple set up node (high avail); doesn't really matter if AIO, just set it to .254/24 of your network
```