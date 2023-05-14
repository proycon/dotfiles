#!/bin/sh

match_folder() {
    find "$HOME/Maildir/" -name '*' -type d  -maxdepth 1 | sort | fzf --reverse
}

folder=$(match_folder)

echo "push 'c$folder<enter>'"
