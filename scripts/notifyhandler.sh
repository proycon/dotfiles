#!/bin/bash

# Receives notifications from MQTT

if command -v play > /dev/null; then
    PLAY="play"
else
    PLAY="mpv --no-video --really-quiet"
fi

if [ -z "$USER" ]; then
    USER=$(whoami)
fi
if [ -z "$HOSTNAME" ]; then
    HOSTNAME=$(hostname)
fi

declare -a fields
declare -a payloadfields

LASTMSG=""
LASTMSGTIME=0

mkdir /tmp/homestatus
chmod go-rwx /tmp/homestatus

while IFS= read -r line
do
	IFS="|" read -ra fields <<< $line; #-a is bash, not posix
	RECEIVETIME=${fields[0]} #time of reception
	TOPIC=${fields[1]}
	PAYLOAD="${fields[2]}"
    echo ">$TOPIC" >&2

    NOW=$(date +%s | tr -d '\n')

    #parse payload
    IFS=":" read -ra payloadfields <<< $PAYLOAD;
    set -- "${payloadfields[@]}"
    MSGTIME="$1" #timestamp?
    case $MSGTIME in
         *[0-9]*)
            shift
            PAYLOAD=$(echo -e "$@" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//') #trim
            echo "   [$MSGTIME] $PAYLOAD" >&2
            TIMEDELTA=$(( NOW - MSGTIME ))
            if [ $TIMEDELTA -ge 600 ] && [ $TOPIC != "home/notify/alarm" ]; then
                echo "Ignoring old message $TOPIC ($TIMEDELTA sec)">&2
                continue
            fi
            ;;
        *)
            MSGTIME=$NOW
            echo "   [?] $PAYLOAD" >&2
    esac


    #clear last message buffer if message is too old
    if [ "$LASTMSG" != "" ] && [ $LASTMSGTIME -ne 0 ]; then
        TIMEDELTA=$(( NOW - LASTMSGTIME ))
        if [ $TIMEDELTA -ge 60 ]; then
            LASTMSG=""
            LASTMSGTIME=0
        fi
    fi

	MSG=""
	case $TOPIC in
		"home/notify/doorbell")
			MSG="The doorbell rang"
			$PLAY ~/dotfiles/media/home/doorbell.ogg &
			;;
		"notify/$USER/irc"|"notify/$USER/telegram"|"notify/$USER/matrix"|"notify/$USER/sms"|"home/notify/message")
            if [ "$PAYLOAD" != "$LASTMSG" ]; then
                MSG="Incoming message: $PAYLOAD"
                $PLAY ~/dotfiles/media/chime.wav &
                LASTMSG="$PAYLOAD"
                LASTMSGTIME=$(date +%s | tr -d '\n')
            fi
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
            amixer set Master 100%
			$PLAY ~/dotfiles/media/home/intruderalert.ogg &
			;;
		"home/notify/armed")
			MSG="System armed"
			$PLAY ~/dotfiles/media/beepin.wav &
			;;
		"home/notify/disarmed")
			MSG="System disarmed"
			$PLAY ~/dotfiles/media/authaccept.mp3 &
			;;
		"home/notify/test")
			MSG="Test notification"
			$PLAY ~/dotfiles/media/beepout.wav &
			;;
		"home/notify/timer"|"notify/$USER/timer")
			MSG="Timer finished"
			$PLAY ~/dotfiles/media/bell.wav &
			;;
        "home/notify/ping")
            if [ "$PAYLOAD" = "$HOSTNAME" ]; then
                $PLAY ~/dotfiles/media/notifyconnect.wav &
            else
                echo "received ping for $PAYLOAD (not us)">&2
            fi
            ;;
		"home/status/"*)
            STATUSFILE="/tmp/homestatus/${TOPIC/home\/status\//}"
            echo "$PAYLOAD" | tr -s " " > $STATUSFILE
            ;;
        *)
            echo "unhandled topic: $TOPIC">&2
            ;;
	esac
	if [ -n "$MSG" ]; then
        MSG="($TIME) $MSG"
		notify-send "$MSG"
        echo "$MSG"
	fi
done < /dev/stdin
