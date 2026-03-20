#!/bin/sh

. ~/.config/river/env.sh

if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
    exec river.new -c ~/dotfiles/river/init.new
else
    exec dbus-run-session -- river.new -c ~/dotfiles/river/init.new
fi
