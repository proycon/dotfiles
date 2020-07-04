#!/bin/bash

# Receives notifications from MQTT

if [ -z "$MQTT_USER" ]; then
    echo "No MQTT user defined">&2
    exit 2
fi

if [ -z "$MQTT_PASSWORD" ]; then
    echo "No MQTT password defined">&2
    exit 2
fi

if [ ! -z "$1" ]; then
    TOPIC="$1"
else
    echo "No topic provided">&2
    exit 2
fi

mosquitto_pub -h anaproy.nl -p 8883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" --cafile /etc/ssl/certs/DST_Root_CA_X3.pem -t "$TOPIC" -m "on"

