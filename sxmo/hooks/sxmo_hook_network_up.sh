#!/bin/sh

. sxmo_common.sh

if ! grep -q rtc "$UNSUSPENDREASONFILE"; then

    #restart notify client (it might prefer the new network connection)
    killall mosquitto_sub notifyhandler.sh notifyclient.sh

    #wait for connection and start
    (
        (ping -c 1 -W 15 anaproy.nl >/dev/null 2>/dev/null && ~/dotfiles/notifyclient.sh)
    ) &

fi