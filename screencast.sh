#!/bin/sh

while [ -f screencast$n.mkv ]; do
	n=$((n+1))
done
filename="screencast$n.mkv"
echo $filename

if [ -n "$1" ]; then
    RES=$(xdpyinfo | grep dimensions | awk '{print $2;}')
    INPUT=":0.0"
else
    if [ "$(hostname)" == "mhysa" ]; then
        RES="3840x2160"
        INPUT=":0.0+2160,0"
    fi
fi

ffmpeg -y \
-f x11grab \
-s "$RES" \
-i "$INPUT" \
-thread_queue_size 1024 \
 -f alsa -ar 44100 -i hw:3 \
-c:v libx264 -r 30 -c:a flac $filename

