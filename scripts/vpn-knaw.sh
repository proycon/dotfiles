#!/bin/sh
sleep 5 && (
    ip route add 195.169.0.0/16 dev ppp0
    ip route add 195.171.119.0/24 dev ppp0
    ip route add 194.171.119.0/24 dev ppp0
    ip route add 194.171.4.0/24 dev ppp0
    ip route add 10.27.1.0/24 dev ppp0
    echo "routes set"
) &
openfortivpn -c /home/proycon/dotfiles.private/openfortivpn-knaw

#openfortivpn-1.20.3-1 with ppp 2.4.9-3 works... latest versions don't!
