nmcli connection add type bridge autoconnect yes con-name br-exnat ifname br-exnat
nmcli connection modify br-exnat ipv4.addresses 172.10.1.1/24 ipv4.method manual
nmcli connection up br-exnat