#!/bin/sh
# configversion: ab967cbbcb9e9cc4d49895887151243f
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors
#
# See man 7 sxmo.states.
#
# This will:
# - turn screen off
# - turn input off
# - launch a demon to blink purple led every 2s
# - check wakelocks and if none suspend after 3s hold

# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

# This hook is called when the system reaches a off state (screen off)

sxmo_led.sh blink red blue &

[ "$SXMO_WM" = "sway" ] && swaymsg mode default
sxmo_wm.sh dpms on
sxmo_wm.sh inputevent touchscreen off

if [ ! -e "$XDG_CACHE_HOME"/sxmo/sxmo.nosuspend ]; then
	sxmo_jobs.sh start periodic_blink \
		sxmo_run_periodically.sh -w 2 -- sxmo_led.sh blink red blue
fi

case "$SXMO_WM" in
	dwm)
		# dmenu will grab input focus (i.e. power button) so kill it before going to
		# screenoff unless proximity lock is running (i.e. there's a phone call).
		if ! sxmo_jobs.sh running proximity_lock -q; then
			sxmo_dmenu.sh close
		fi
		;;
esac

sxmo_jobs.sh stop idle_locker

wait

peanutbuffer &
