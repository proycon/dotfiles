#!/bin/sh
# configversion: 5b14e4278b1a58b8efae709a85913ae1
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

# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

# do nothing if active call
if ! sxmo_modemcall.sh list_active_calls | grep -q active; then

	if [ ! -f "$XDG_CONFIG_HOME"/sxmo/.noring ]; then
		mpv --no-resume-playback --quiet --no-video "$SXMO_TEXTSOUND" >> /dev/null 2>&1
	fi

	if [ ! -f "$XDG_CONFIG_HOME"/sxmo/.novibrate ]; then
		sxmo_vibrate 500 "${SXMO_VIBRATE_STRENGTH:-1}"
	fi

fi

~/dotfiles/notifysend.sh notify/proycon/sms "$@" &
