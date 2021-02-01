#!/bin/sh
codepoint=$(printf '%x' \'$1)
if [ -n "$codepoint" ]; then
    fc-list ":charset=$codepoint"
fi

