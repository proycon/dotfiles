#!/bin/bash

# Receives notifications from MQTT

PLAY="play"

if [ -f ~/.mqtt_secrets ]; then
    source ~/.mqtt_secrets
fi

if [ -z "$MQTT_USER" ]; then
    echo "No MQTT user defined">&2
    exit 2
fi

if [ -z "$MQTT_PASSWORD" ]; then
    echo "No MQTT password defined">&2
    exit 2
fi

mkfifo /tmp/notifications

mosquitto_sub -h anaproy.nl -p 8883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" --cafile /etc/ssl/certs/DST_Root_CA_X3.pem --remove-retained -t '#' -F "@Y@m@d-@H:@M:@S\t%t\t%p" > /tmp/notifications &


while IFS= read -r line
do
	IFS="\t" read -ra fields <<< $line;
	DATETIME=${fields[0]}
	TOPIC=${fields[1]}
	PAYLOAD="${fields[2]}"

	MSG=""
	case $TOPIC in
		"home/notify/doorbell")
			MSG="$DATETIME\tThe doorbell rang"
			$PLAY ~/dotfiles/media/home/doorbell.ogg &
			;;
		"notify/$USER/irc"|"notify/$USER/telegram"|"notify/$USER/matrix"|"notify/$USER/sms"|"home/notify/message")
			MSG="$DATETIME\tIncoming message: $PAYLOAD"
			$PLAY ~/dotfiles/media/chime.wav &
			;;
		"notify/$USER/mail")
			MSG="$DATETIME\tIncoming mail: $PAYLOAD"
			$PLAY ~/dotfiles/media/newmail.wav &
			;;
		"notify/$USER/phone")
			MSG="$DATETIME\tIncoming call: $PAYLOAD"
			$PLAY ~/dotfiles/media/phone.wav &
			;;
		"home/notify/alarm")
			MSG="$DATETIME\tINTRUDER ALERT, CHECK IMMEDIATELY"
			$PLAY ~/dotfiles/media/redalert.wav &
			;;
		"home/notify/armed")
			MSG="$DATETIME\tSystem armed"
			$PLAY ~/dotfiles/media/beepin.wav &
			;;
		"home/notify/disarmed")
			MSG="$DATETIME\tSystem disarmed"
			$PLAY ~/dotfiles/media/beepout.wav &
			;;
		"home/notify/timer"|"notify/$USER/timer")
			MSG="$DATETIME\tTimer finished"
			$PLAY ~/dotfiles/media/bell.wav &
			;;
        *)
            echo "unhandled topic: $TOPIC">&2
            ;;
	esac
	if [ ! -z "$MSG" ]; then
		notify-send "$MSG"
		echo $MSG >> ~/notifications.log
	fi
done < /tmp/notifications

killall mosquitto_sub
rm /tmp/notifications
