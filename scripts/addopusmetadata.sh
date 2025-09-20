#!/bin/sh
for f in "$@"; do
    artist=$(echo "$f" | cut -d "-" -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    title=$(echo "$f" | cut -d "-" -f "2-" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*.opus$//')
    if [ -n "$artist" ] && [ -n "$title" ]; then
        echo "artist: $artist | title: $title"
        ffmpeg -i "$f" -map 0 -c copy -metadata:s title="$title" -metadata:s artist="$artist" "tmp.$f" &&\
        mv -f "tmp.$f" "$f"
    fi
done
