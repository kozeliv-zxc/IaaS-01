if nmcli -g connection.uuid connection show "br-exnat" 2>/dev/null; then
    echo "Profile exists!"
else
	nmcli connection add type bridge autoconnect yes con-name br-exnat ifname br-exnat
	nmcli connection modify br-exnat ipv4.addresses 10.0.0.1/24 ipv4.method manual
	nmcli connection up br-exnat
fi