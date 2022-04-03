#!/bin/sh
# configversion: df124d13858ec019518b832ce926fb3a
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# This script is executed after you received a text, mms, or vvm
# You can use it to play a notification sound or forward the sms elsewhere

# The following parameters are provided:
# $1 = Contact Name or Number (if number not in contacts)
# $2 = Text (or 'VVM' if a vvm)
# mms and vvm will include these parameters:
# $3 = MMS or VVM payload ID
# Finally, mms may include this parameter:
# $4 = Group Contact Name or Number (if number not in contacts)

~/dotfiles/notifysend.sh notify/proycon/sms "$@" &

mpv --quiet --no-video /usr/share/sxmo/notify.ogg
