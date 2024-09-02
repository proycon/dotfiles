#!/bin/sh
# configversion: aec40a4fa4dcd04cc52ef8001970445d
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2023 Sxmo Contributors

# This is called when a network goes up.
# $1 = device name (e.g. wlan0)
# $2 = device type (e.g. wifi)

# Notify the user if a network goes up.
sxmo_notify_user.sh "$2 ($1) up."
killall -9 mosquitto_sub
~/dotfiles/scripts/homecommand.sh status &
HOUR=$(date +%H) 
if [ "$HOUR" -ge 09 ] && [ "$HOUR" -le 22 ]; then
    sxmo_wakelock.sh timeout --kill-after=7s --signal=9 5s  mpv --no-video --quiet ~/lighthome/media/connect.wav 
fi

# tell us wifi strength
#if [ "$2" = "wifi" ]; then
#	sxmo_notify_user.sh "SIGNAL STRENGTH: $(nmcli -f IN-USE,SIGNAL,SSID device wifi |awk '/^\*/{if (NR!=1) {print $2}}')"
#fi
