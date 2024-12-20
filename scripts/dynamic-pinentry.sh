#!/bin/sh
set -eu

if tty -s; then
    if command -v pinentry-curses; then
        exec pinentry-curses "$@"
    elif command -v pinentry-tty; then
        exec pinentry-tty "$@"
    fi
else
   if [ -n "$WAYLAND_DISPLAY" ] && command -v pinentry-wayprompt; then
        exec pinentry-wayprompt "$@"
   elif command -v pinentry-gnome3; then
        exec pinentry-gnome3 "$@"
   elif command -v pinentry-qt; then
        exec pinentry-qt "$@"
   fi
fi
echo "No suitable pinentry found"
exit 1
