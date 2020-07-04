#!/bin/bash
while true; do
    fping -c1 -t5000 anaproy.nl > /dev/null 2> /dev/null
    if [ "$?" -eq "0" ]; then
        echo "starting client"
        play ~/dotfiles/media/notifyconnect.wav
        ~/dotfiles/notifyclient.sh
        play ~/dotfiles/media/error.wav
    else
        echo "no network"
        sleep 5
    fi
done
