#!/bin/sh

if [ -e ~/.mqtt_secrets ]; then
    . ~/.mqtt_secrets
elif [ -e /etc/mqtt_secrets ]; then
    . /etc/mqtt_secrets
fi

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

if [ -n "$2" ]; then
    PAYLOAD="$2"
else
    PAYLOAD="ON"
fi

if [ -z "$HOST" ]; then
    HOST=$(hostname);
fi

if [ -z "$MQTT_HOST" ]; then
    MQTT_HOST="anaproy.nl"
fi

if [ -e /etc/ssl/certs/ISRG_Root_X1.pem ]; then
    CACERT="/etc/ssl/certs/ISRG_Root_X1.pem"
elif [ -e /etc/ssl/certs/ca-cert-ISRG_Root_X1.pem ]; then
    CACERT="/etc/ssl/certs/ca-cert-ISRG_Root_X1.pem"
elif [ -e /etc/ssl/certs/DST_Root_CA_X3.pem ]; then
    CACERT="/etc/ssl/certs/DST_Root_CA_X3.pem"
elif [ -e /etc/ssl/certs/ca-cert-DST_Root_CA_X3.pem ]; then
    CACERT="/etc/ssl/certs/ca-cert-DST_Root_CA_X3.pem"
else
    echo "CA Certificate not found">&2
    exit 2
fi


echo "Sending: $TOPIC - $PAYLOAD">&2

mosquitto_pub -I "$HOST.notifysend" -h "$MQTT_HOST" -p 8883 -u "$MQTT_USER" -P "$MQTT_PASSWORD" --cafile $CACERT -t "$TOPIC" -m "$PAYLOAD" --qos 1 $MQTT_OPTIONS
exit $?
