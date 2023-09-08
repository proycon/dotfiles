#!/bin/sh
# configversion: aec40a4fa4dcd04cc52ef8001970445d
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2023 Sxmo Contributors

# This is called when a network goes up.
# $1 = device name (e.g. wlan0)
# $2 = device type (e.g. wifi)

# Notify the user if a network goes up.
sxmo_notify_user.sh "$2 ($1) up."
killall mosquitto_sub
~/dotfiles/scripts/homecommand.sh status &
mpv --no-video --quiet ~/lighthome/media/connect.wav 

# tell us wifi strength
#if [ "$2" = "wifi" ]; then
#	sxmo_notify_user.sh "SIGNAL STRENGTH: $(nmcli -f IN-USE,SIGNAL,SSID device wifi |awk '/^\*/{if (NR!=1) {print $2}}')"
#fi
