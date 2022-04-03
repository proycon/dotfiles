#!/bin/sh
# configversion: 33251ab5f815798ec1b21401462a48e0
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. "$(which sxmo_common.sh)"

# in case of weird crash
echo "unlock" > "$SXMO_STATE"
[ -f "$SXMO_UNSUSPENDREASONFILE" ] && rm -f "$SXMO_UNSUSPENDREASONFILE"

# Play a funky startup tune if you want (disabled by default)
#mpv --quiet --no-video ~/welcome.ogg &

~/dotfiles/notifyclient.sh &

case "$SXMO_WM" in
	sway)
		sxmo_daemons.sh start desktop_notifier mako
		sxmo_daemons.sh start wob sxmo_wob.sh
		sxmo_daemons.sh start menu_mode_toggler sxmo_menumode_toggler.sh
		;;
	dwm)
		sxmo_daemons.sh start desktop_notifier dunst

		# Auto hide cursor with touchscreen, Show it with a mouse
		if command -v "unclutter-xfixes" > /dev/null; then
			set -- unclutter-xfixes
		else
			set -- unclutter
		fi
		sxmo_daemons.sh start unclutter_xfixes "$1" --hide-on-touch --start-hidden

		# Set a pretty wallpaper
		feh --bg-fill /usr/share/sxmo/background.jpg

		sxmo_daemons.sh start autocutsel_1 autocutsel
		sxmo_daemons.sh start autocutsel_2 autocutsel -selection PRIMARY
		sxmo_daemons.sh start statusbar_xsetroot sxmo_status_xsetroot.sh
		;;
esac

if [ -f "${SXMO_MMS_BASE_DIR:-"$HOME"/.mms/modemmanager}/mms" ]; then
	sxmo_daemons.sh start mmsd mmsdtng "$SXMO_MMSD_ARGS"
fi

if [ -f "${SXMO_VVM_BASE_DIR:-"$HOME"/.vvm/modemmanager}/vvm" ]; then
	sxmo_daemons.sh start vvmd vvmd "$SXMO_VVMD_ARGS"
fi

# Start the desktop widget (e.g. clock)
sxmo_daemons.sh start desktop_widget sxmo_hook_desktop_widget.sh

# Periodically update some status bar components
sxmo_hook_statusbar.sh all
sxmo_daemons.sh start statusbar_periodics sxmo_run_periodically.sh 55 \
	sxmo_hook_statusbar.sh periodics

# Monitor the battery
sxmo_daemons.sh start battery_monitor sxmo_battery_monitor.sh

# It watch network changes and update the status bar icon by example
sxmo_daemons.sh start network_monitor sxmo_networkmonitor.sh

# The daemon that display notifications popup messages
sxmo_daemons.sh start notification_monitor sxmo_notificationmonitor.sh

# To setup initial lock state
sxmo_hook_unlock.sh

sxmo_daemons.sh start pipewire pipewire

# Verify modemmanager and eg25-manager are running
if ! sxmo_modemdaemons.sh status; then
	sxmo_notify_user.sh --urgency=critical "Warning! Modem daemons are not running."
else

	(
		sleep 5 # let some time to pipewire
		sxmo_daemons.sh start callaudiod callaudiod

		# Turn on the dbus-monitors for modem-related tasks
		sxmo_daemons.sh start modem_monitor sxmo_modemmonitor.sh
	) &

	# Prevent crust for 120s if this is a reboot (uptime < 3mins)
	if [ "$(cut -d '.' -f1 < /proc/uptime)" -lt 180 ]; then
		sxmo_daemons.sh start modem_nocrust sleep 120
	fi
fi

sxmo_migrate.sh state || sxmo_notify_user.sh --urgency=critical \
	"Config needs migration" "$? file(s) in your sxmo configuration are out of date and disabled - using defaults until you migrate (run sxmo_migrate.sh)"
