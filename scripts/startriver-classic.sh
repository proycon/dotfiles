#!/bin/sh

. ~/.config/river/env.sh

if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
    exec river
else
    exec dbus-run-session -- river
fi
