#!/bin/sh
set -eu

if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
   if command -v pinentry-bemenu; then
    exec pinentry-bemenu "$@"
   elif command -v pinentry-gnome3; then
    exec pinentry-gnome3 "$@"
   elif command -v pinentry-qt; then
    exec pinentry-qt "$@"
   fi
fi

if command -v pinentry-curses; then
    exec pinentry-curses "$@"
fi
echo "No suitable pinentry found"
exit 1
