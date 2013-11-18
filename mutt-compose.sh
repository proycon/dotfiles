#!/bin/sh
# set the screen window title to the message receiver
awk -F 'To: ' '/^To:/ { print "\033k" $2 "\033\\" }' "$1"
mutt -F ~/.mutt_compose -H "$1"
rm "$1"
