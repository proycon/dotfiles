#!/bin/sh
sleep 10 && (
    ip route add 195.169.0.0/16 dev ppp0
    ip route add 195.171.119/24 dev ppp0
    ip route add 10.27.1.0/24 dev ppp0
    ip route add 194.171.119/24 dev ppp0
) &
openfortivpn -c /home/proycon/dotfiles.private/openfortivpn-knaw
