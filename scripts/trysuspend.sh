#!/bin/sh

ssh_connected() {
	netstat -tn | awk '
		BEGIN { status = 1 }
		$4 ~ /:22$/ { status = 0; exit }
		END { exit status }
		'
}

if ! ssh_connected && ! pidof notmuch rsync pacman git apk scp cp tar zip unzip mpv steam X-Plane-x86_64; then
    LOADAVG=$(cut -d" " -f 2 /proc/loadavg | cut -d "." -f 1)
    if [ "$LOADAVG" -le 3 ]; then
        if [ "$HOSTNAME" = "pollux" ]; then
            pkill -f streamdeck.py
        fi
        echo "auto suspending">&2
        if ! pidof waylock; then
            ~/dotfiles/scripts/lock.sh &
            sleep 3
        fi
        if command -v systemctl; then
            systemctl suspend
        elif command -v zzz; then
            umountssh &&\
            nmcli dev down wlan0 &&\
            wlopm --off eDP-1 &&\
            doas zzz
            wlopm --on eDP-1
            nmcli dev up wlan0
        fi
    fi
else
    echo "suspension blocked">&2
fi
