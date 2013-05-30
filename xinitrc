#!/bin/zsh
export LANG=pt_PT.UTF-8
export LC_ALL=pt_PT.UTF-8
source ~/.zshrc
~/.config/openbox/autostart.sh
exec openbox
#exec dbus-launch --exit-with-session startxfce4
