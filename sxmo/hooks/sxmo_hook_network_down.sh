#!/bin/sh
# configversion: 29ec7910bd4c699ad1a8c84f74e6aeb5
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2023 Sxmo Contributors

# This is called when any network goes down.
# $1 = device name (eg. wlan0)
# $2 = device type (eg. wifi)

# Some examples:

# Notify the user when a network goes down.
killall -9 mosquitto_sub
sxmo_notify_user.sh "$2 ($1) down."
~/dotfiles/scripts/homecommand.sh status &
HOUR=$(date +%H) 
if [ "$HOUR" -ge 09 ] && [ "$HOUR" -le 22 ]; then
    sxmo_wakelock.sh timeout --kill-after=7s --signal=9 5s  mpv --no-video --quiet ~/lighthome/media/disconnect.wav 
fi
# Toggle the data connection when wifi goes down.
#if [ "$2" = "wifi" ]; then
#	nmcli c down MYMINT
#	nmcli c up MYMINT
#fi
