#!/bin/sh
while true; do
    echo "starting rivermap....">&2
    rivermap -d | while read -r line; do
        #write to temporary file (memory-backed fs)
        echo "$line"  > "$XDG_RUNTIME_DIR/rivermap.state"
        #send signal to parent
        kill -37 "$1"
    done
    echo "rivermap died....">&2
    sleep 2
done
echo "rivermap wrapper died....">&2
