#!/bin/bash
while true; do
    fping -c1 -t5000 anaproy.nl > /dev/null 2> /dev/null
    if [ "$?" -eq "0" ]; then
        echo "starting notify client"
        if [ ! -f /tmp/silentreconnect ]; then
            mpv --no-video --really-quiet ~/dotfiles/media/notifyconnect.wav
        fi

        ~/dotfiles/notifyclient.sh > ~/.notifications.log 2> ~/.notifications.err
        echo  "notify client ended"
        if [ ! -f /tmp/silentreconnect ]; then
            mpv --no-video --really-quiet ~/dotfiles/media/error.wav
        fi
    else
        echo "no network"
        sleep 5
    fi
done
