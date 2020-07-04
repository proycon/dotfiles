#!/bin/bash

# Receives notifications from MQTT

PLAY="play"

if [ -z "$USER" ]; then
    USER=$(whoami)
fi

declare -a fields

while IFS= read -r line
do
	IFS="|" read -ra fields <<< $line;
	TIME=${fields[0]}
	TOPIC=${fields[1]}
	PAYLOAD="${fields[2]}"
    echo ">$TOPIC" >&2

	MSG=""
	case $TOPIC in
		"home/notify/doorbell")
			MSG="The doorbell rang"
			$PLAY ~/dotfiles/media/home/doorbell.ogg &
			;;
		"notify/$USER/irc"|"notify/$USER/telegram"|"notify/$USER/matrix"|"notify/$USER/sms"|"home/notify/message")
			MSG="Incoming message: $PAYLOAD"
			$PLAY ~/dotfiles/media/chime.wav &
			;;
		"notify/$USER/mail")
			MSG="Incoming mail: $PAYLOAD"
			$PLAY ~/dotfiles/media/newmail.wav &
			;;
		"notify/$USER/phone")
			MSG="Incoming call: $PAYLOAD"
			$PLAY ~/dotfiles/media/phone.wav &
			;;
		"home/notify/alarm")
			MSG="INTRUDER ALERT, CHECK IMMEDIATELY"
			$PLAY ~/dotfiles/media/redalert.wav &
			;;
		"home/notify/armed")
			MSG="System armed"
			$PLAY ~/dotfiles/media/beepin.wav &
			;;
		"home/notify/disarmed")
			MSG="System disarmed"
			$PLAY ~/dotfiles/media/beepout.wav &
			;;
		"home/notify/timer"|"notify/$USER/timer")
			MSG="Timer finished"
			$PLAY ~/dotfiles/media/bell.wav &
			;;
        *)
            echo "unhandled topic: $TOPIC">&2
            ;;
	esac
	if [ ! -z "$MSG" ]; then
        MSG="($TIME) $MSG"
		notify-send "$MSG"
        echo $MSG
	fi
done < /dev/stdin
