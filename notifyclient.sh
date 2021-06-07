#!/bin/bash

if [ -f ~/.mqtt_secrets ]; then
    source ~/.mqtt_secrets
fi

pidof mosquito_sub && exit 1 #already running

if [ -z "$MQTT_USER" ]; then
    echo "No MQTT user defined">&2
    exit 2
fi

if [ -z "$MQTT_PASSWORD" ]; then
    echo "No MQTT password defined">&2
    exit 2
fi

if [ -z "$HOST" ]; then
    HOST=$(hostname);
fi

if [ -z "$MQTT_HOST" ]; then
    MQTT_HOST="anaproy.nl"
fi

if [ -e /etc/ssl/certs/DST_Root_CA_X3.pem ]; then
    CACERT="/etc/ssl/certs/DST_Root_CA_X3.pem"
elif [ -e /etc/ssl/certs/ca-cert-DST_Root_CA_X3.pem ]; then
    CACERT="/etc/ssl/certs/ca-cert-DST_Root_CA_X3.pem"
else
    echo "CA Certificate not found">&2
    exit 2
fi

if [ ! -f /tmp/.notifyclient.silent ]; then
    mpv --no-video --really-quiet ~/dotfiles/media/notifyconnect.wav &
fi

echo "Starting notifyclient">&2
mosquitto_sub -c -q 1 -i $HOST.notifyclient -h $MQTT_HOST -p 8883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" --cafile $CACERT -t '#' -F "@H:@M:@S|%t|%p" $MQTT_OPTIONS "$@" | ~/dotfiles/notifyhandler.sh >> ~/.notifications.log 2>> ~/.notifications.err

if [ ! -f /tmp/.notifyclient.silent ]; then
    mpv --no-video --really-quiet ~/dotfiles/media/error.wav
fi
