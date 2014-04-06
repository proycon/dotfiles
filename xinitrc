#!/bin/zsh
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
source ~/.zshrc
~/.config/openbox/autostart.sh
exec dbus-launch openbox
#exec dbus-launch --exit-with-session startxfce4
