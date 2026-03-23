#!/bin/sh

. ~/.config/river/env.sh

if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
    exec river-classic -c ~/dotfiles/river/init.classic
else
    exec dbus-run-session -- river-classic -c ~/dotfiles/river/init.classic
fi
