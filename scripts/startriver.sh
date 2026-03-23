#!/bin/sh

. ~/.config/river/env.sh

if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
    exec river -c ~/dotfiles/river/init
else
    exec dbus-run-session -- river -c ~/dotfiles/river/init
fi
