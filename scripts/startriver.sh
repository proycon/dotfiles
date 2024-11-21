#!/bin/sh

. ~/.config/river/env.sh

if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
    exec dbus-run-session -- river
else
    exec river
fi
