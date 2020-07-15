#!/bin/bash

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

mosquitto_sub -I $HOST -h $MQTT_HOST -p 8883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" --cafile $CACERT --remove-retained -t '#' -F "@H:@M:@S|%t|%p" $MQTT_OPTIONS | ~/dotfiles/notifyhandler.sh
