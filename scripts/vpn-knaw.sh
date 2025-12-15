#!/bin/sh

#sleep for a bit so we only run this when the connection is up (bit patchy but works)
sleep 4 && (
    IF=$(nmcli connection show --active | grep -E "(wifi|ethernet)" | head -n 1 |  tr -s " " | cut -d" " -f 6)
    if [ -z "$IF" ]; then
        IF=enp10s0
    fi
    VPN_GATEWAY=$(ip --json addr show ppp0 | jq -r '.[0].addr_info[0].local')
    ip route add 195.169.0.0/16 via $VPN_GATEWAY dev ppp0
    ip route add 195.171.119.0/24 via $VPN_GATEWAY dev ppp0
    ip route add 194.171.119.0/24 via $VPN_GATEWAY dev ppp0
    ip route add 194.171.4.0/24 via $VPN_GATEWAY dev ppp0
    ip route add 10.27.1.0/24 via $VPN_GATEWAY dev ppp0
    ip route add 10.26.4.0/24 via $VPN_GATEWAY dev ppp0
    ip route add 10.24.0.0/16 via $VPN_GATEWAY dev ppp0
    ip route add $VPN_GATEWAY via 192.168.0.1 dev "$IF" || route del $VPN_GATEWAY #delete the existing one if this fails
    ip route add $VPN_GATEWAY via 192.168.0.1 dev "$IF" #and retry...
    echo "routes set"
) &

openfortivpn -c /home/proycon/dotfiles.private/openfortivpn-knaw $@
