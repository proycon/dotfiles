#!/bin/sh
# find tunnel device. probably tun0
TUNDEV=$(ip route |grep default |grep tun |awk '{print $5}')
if [ "$TUNDEV" = "" ]; then 
    echo "no tunnel found" 
    exit 1
fi
# find gateway for tunnel device
TUNGW=$(ip route |grep default |grep "$TUNDEV" |awk '{print $3}')
# delete all routes that run via tunnel device
ip route |grep "$TUNDEV"  |grep -v scope | ( while read -r line; do sudo ip route del "$line"; done )
# add route to network via tunnel device
sudo ip route add 131.174.0.0/16 via "$TUNGW" dev "$TUNDEV"
