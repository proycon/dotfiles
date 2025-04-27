#!/bin/sh
# configversion: 5af98b088d38ff15338bc0e0a9fe9d33
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# This hook is called when the ModemManager1.Modem signals a StateChanged

# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

# see networkmanager documentation for state names
# oldstate="$1"
newstate="$2"
# reason="$3" # 0 or 1

sxmo_debug "$2 (old: $1 [reason: $3])"

case "$newstate" in
	"locked")
		sxmo_log "State is locked.  Attempting to unlock."
		if ! pgrep -f "sxmo_unlocksim.sh" >/dev/null; then
            if [ "$HOSTNAME" = "toren" ]; then
                mmcli -i 0 --pin $(pass sim) || sxmo_unlocksim.sh
            else
                sxmo_unlocksim.sh
            fi
		fi
		;;
	"enabling")
		sxmo_log "State is enabling. Clearing stale call files."
		rm "$XDG_RUNTIME_DIR"/sxmo_calls/* 2>/dev/null
		rm -f "$SXMO_NOTIFDIR"/incomingcall* 2>/dev/null
		;;
	"registered")
		sxmo_log "State is registered.  Checking for calls and messages."

		# kill the pin-entry dmenu if still open
		pkill -f sxmo_unlocksim.sh

		sxmo_modem.sh checkforfinishedcalls
		sxmo_modem.sh checkforincomingcalls
		sxmo_modem.sh checkfornewtexts
		sxmo_modem.sh checkforstucksms
		if [ -f "${SXMO_MMS_BASE_DIR:-"$HOME"/.mms/modemmanager}/mms" ]; then
			sxmo_mms.sh checkforlostmms
		fi

		# An example of something else to do here!
		#if ! ping -Iwwan0 -q -c 1 -W 10 www.google.com >/dev/null; then
		#	sxmo_log "ping failed."
		#	nmcli c down "MINTY"
		#	nmcli c up "MINTY"
		#else
		#	sxmo_log "ping ok."
		#fi
		;;
esac
