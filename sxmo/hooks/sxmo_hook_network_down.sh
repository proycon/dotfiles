#!/bin/sh

#stop notify client if we lost all networks
connectivity=$(nmcli net connectivity)
if [ $connectivity == "none" ]; then
    killall mosquitto_sub notifyhandler.sh notifyclient.sh #kill the one already running

fi
