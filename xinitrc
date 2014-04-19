#!/bin/zsh
export LANG=ru_RU.UTF-8
export LANGUAGE=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8
source ~/.zshrc
~/.config/openbox/autostart.sh
exec dbus-launch openbox
#exec dbus-launch --exit-with-session startxfce4
