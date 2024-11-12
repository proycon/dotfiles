#!/bin/sh

ssh_connected() {
	netstat -tn | awk '
		BEGIN { status = 1 }
		$4 ~ /:22$/ { status = 0; exit }
		END { exit status }
		'
}

if ! ssh_connected && ! pidof notmuch rsync pacman git apk scp cp tar zip unzip; then
    LOADAVG=$(cut -d" " -f 2 /proc/loadavg | cut -d "." -f 1)
    if [ "$LOADAVG" -le 3 ]; then
        echo "auto suspending">&2
        if ! pidof waylock; then
            ~/dotfiles/scripts/lock.sh &
            sleep 3
        fi
        systemctl suspend
    fi
else
    echo "suspension blocked">&2
fi
