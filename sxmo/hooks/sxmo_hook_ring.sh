#!/bin/sh
# configversion: c582971c48f67bb038dd16bbbec081fa
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# This script is executed (asynchronously) when you get an incoming call
# You can use it to play a ring tone

# $1 = Contact Name or Number (if not in contacts)

# Only vibrate if you already got an active call
if sxmo_modemcall.sh list_active_calls \
	| grep -v ringing-in \
	| grep -q .; then
	sxmo_vibrate 1500
	exit
fi

# Shallow if you have more than one ringing call
if ! sxmo_modemcall.sh list_active_calls \
	| grep -c ringing-in \
	| grep -q 1; then
	exit
fi

# Start the mpv ring until another hook kill it or the max (10) is reached
mpv --quiet --no-video --loop=10 /usr/share/sxmo/ring.ogg &
MPVID=$!
echo "$MPVID" > "$XDG_RUNTIME_DIR/sxmo.ring.pid"

~/dotfiles/notifysend.sh notify/proycon/phone "$1" &

# Vibrate while mpv is running
while kill -0 $MPVID; do
		sxmo_vibrate 1500
		sleep 0.5
done
