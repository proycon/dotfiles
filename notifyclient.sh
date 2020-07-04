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

mosquitto_sub -I $HOST -h anaproy.nl -p 8883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" --cafile /etc/ssl/certs/DST_Root_CA_X3.pem --remove-retained -t '#' -F "@Y@m@d-@H:@M:@S|%t|%p" | ~/dotfiles/notifyhandler.sh
