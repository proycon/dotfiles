#!/bin/bash
~/dotfiles/homestatus.sh pango loop | wayout --font "Monospace 20" --feed-par --height 500 $1 >&2 2> /tmp/wayout.log
