#!/bin/sh
die() {
    echo "$@">&2
    exit 2
}
if [ -n "$1" ]; then
    BARPID=$1
else
    die "Pass bar pid..."
fi
while true; do
    echo "starting rivermap....">&2
    rivermap -d | while read -r line; do
        #write to temporary file (memory-backed fs)
        echo "$line"  > "$XDG_RUNTIME_DIR/rivermap.state"
        #send signal to parent
        kill -37 "$BARPID" || die "bar is dead"
    done
    echo "rivermap died....">&2
    sleep 1
done
die "rivermap wrapper died...."
