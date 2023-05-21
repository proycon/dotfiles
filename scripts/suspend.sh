#!/bin/sh
~/dotfiles/scripts/lock.sh &
sleep 5
while pidof notmuch rsync pacman git; do
    sleep 5
done
systemctl suspend
