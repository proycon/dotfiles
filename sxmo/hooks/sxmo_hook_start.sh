#!/bin/sh
# configversion: e68cefafc3d6e8e0cb0ff95f96d9dc6b
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

# Create xdg user directories, such as ~/Pictures
xdg-user-dirs-update

#kill possibly stale things from previous session
killall fcitx5
killall peanutbutter
killall client.sh
killall mosquitto_sub
killall -9 mpv

sxmo_jobs.sh start daemon_manager superd

# let time to superd to start correctly
while ! superctl status > /dev/null 2>&1; do
	sleep 0.5
done

# Not dangerous if "locker" isn't an available state
sxmo_state.sh set locker

if [ -n "$SXMO_ROTATE_START" ]; then
	sxmo_rotate.sh
fi

# Load our sound daemons

if [ -z "$SXMO_NO_AUDIO" ]; then
	if [ "$(command -v pulseaudio)" ]; then
		superctl start pulseaudio
	elif [ "$(command -v pipewire)" ]; then
		# pipewire-pulse will start pipewire
		superctl start pipewire-pulse
		superctl start wireplumber
	fi

	# monitor for headphone for statusbar
	superctl start sxmo_soundmonitor
fi

# Periodically update some status bar components
sxmo_hook_statusbar.sh all
sxmo_jobs.sh start statusbar_periodics sxmo_run_aligned.sh 60 \
	sxmo_hook_statusbar.sh periodics

# mako/dunst are required for warnings.
# load some other little things here too.
case "$SXMO_WM" in
	sway)
		superctl start mako
		superctl start sxmo_wob
		superctl start sxmo_menumode_toggler
		superctl start bonsaid
		;;
	dwm)
		superctl start dunst

		# Auto hide cursor with touchscreen, Show it with a mouse
		if command -v "unclutter-xfixes" > /dev/null; then
			set -- unclutter-xfixes
		else
			set -- unclutter
		fi
		superctl start "$1"

		superctl start autocutsel
		superctl start autocutsel-primary
		superctl start sxmo-x11-status
		superctl start bonsaid
		[ -n "$SXMO_MONITOR" ] && xrandr --output "$SXMO_MONITOR" --primary
		;;
esac

# Turn on auto-suspend
if sxmo_wakelock.sh isenabled; then
	sxmo_wakelock.sh lock sxmo_not_suspendable infinite
	superctl start sxmo_autosuspend
fi

# To setup initial unlock state
sxmo_state.sh set unlock

# Turn on lisgd
if [ ! -e "$XDG_CACHE_HOME"/sxmo/sxmo.nogesture ]; then
	superctl start sxmo_hook_lisgd
fi

if [ -z "$SXMO_NO_MODEM" ] && command -v ModemManager > /dev/null; then
	# Turn on the dbus-monitors for modem-related tasks
	superctl start sxmo_modemmonitor

	# place a wakelock for 120s to allow the modem to fully warm up (eg25 +
	# elogind/systemd would do this for us, but we don't use those.)
	sxmo_wakelock.sh lock sxmo_modem_warming_up 120s
fi

# Start the desktop wallpaper
superctl start sxmo_bg

# Start the desktop widget (e.g. clock)
superctl start sxmo_conky

# Monitor the battery
superctl start sxmo_battery_monitor

# It watch network changes and update the status bar icon by example
superctl start sxmo_networkmonitor

# The daemon that display notifications popup messages
superctl start sxmo_notificationmonitor

# Play a funky startup tune if you want (disabled by default)
mpv --quiet --no-video ~/welcome.ogg &

# mmsd and vvmd
if [ -z "$SXMO_NO_MODEM" ]; then
	if [ -f "${SXMO_MMS_BASE_DIR:-"$HOME"/.mms/modemmanager}/mms" ]; then
		superctl start mmsd-tng
	fi

	if [ -f "${SXMO_VVM_BASE_DIR:-"$HOME"/.vvm/modemmanager}/vvm" ]; then
		superctl start vvmd
	fi
fi

# add some warnings if things are not setup correctly
if ! command -v "sxmo_deviceprofile_$SXMO_DEVICE_NAME.sh";  then
	sxmo_notify_user.sh --urgency=critical \
		"No deviceprofile found $SXMO_DEVICE_NAME. See: https://sxmo.org/deviceprofile"
fi

sxmo_migrate.sh state || sxmo_notify_user.sh --urgency=critical \
	"Config needs migration" "$? file(s) in your sxmo configuration are out of date and disabled - using defaults until you migrate (run sxmo_migrate.sh)"

GLFW_IM_MODULE=fcitx
INPUT_METHOD=fcitx
XMODIFIERS=@im=fcitx
IMSETTINGS_MODULE=fcitx
QT_IM_MODULE=fcitx
export GLFW_IM_MODULE INPUT_METHOD XMODIFIERS IMSETTINGS_MODULE QT_IM_MODULE
fcitx5 &

(sleep 10 && ~/lighthome/client.sh > /dev/null 2>&1)
