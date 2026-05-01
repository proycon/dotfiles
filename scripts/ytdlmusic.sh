#!/bin/sh

die() {
    echo "$@">&2
    exit 2
}

yt-dlp -x "$1" | tee /tmp/ytdlmusic
outfile=$(cat /tmp/ytdlmusic | grep "\[ExtractAudio\] Destination:" | cut -d: -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
if [ -e "$outfile" ]; then
    newname=$(echo "$outfile" | cut -d'[' -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    newname=$(echo "$newname" | cut -d'(' -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    mv "$outfile" "$newname.opus" || die "unable to rename file"
    ~/dotfiles/scripts/addopusmetadata.sh "$newname.opus" || die "extracting metadata failed"
else
    die "No output produced"
fi
