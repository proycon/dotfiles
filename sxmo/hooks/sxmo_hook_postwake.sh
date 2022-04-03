#!/bin/sh
# configversion: 24a037ef7ac86d02fb95198838c868b5
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

. sxmo_common.sh

UNSUSPENDREASON="$1"

#The UNSUSPENDREASON can be "usb power", "modem", "rtc" (real-time clock
#periodic wakeup) or "button". You will likely want to check against this and
#decide what to do

if [ "$UNSUSPENDREASON" != "modem" ]; then
	NETWORKRTCSCAN="/sys/module/8723cs/parameters/rtw_scan_interval_thr"
	echo 1200 > "$NETWORKRTCSCAN"
fi

sxmo_hook_statusbar.sh time

if [ "$UNSUSPENDREASON" = "rtc" ] || [ "$UNSUSPENDREASON" = "usb power" ]; then
	# We stopped it in presuspend
	sxmo_daemons.sh start periodic_blink sxmo_run_periodically.sh 2 sxmo_uniq_exec.sh sxmo_led.sh blink red blue
fi

# Add here whatever you want to do

#request status update from home automation
~/dotfiles/notifysend.sh "home/command/status" "ON"
