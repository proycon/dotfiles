#!/bin/bash

while [[ -f screencast$n.mkv ]]
do
	n=$((n+1))
done
filename="screencast$n.mkv"
echo $filename

ffmpeg -y \
-f x11grab \
-s $(xdpyinfo | grep dimensions | awk '{print $2;}') \
-i :0.0 \
-thread_queue_size 1024 \
-c:v libx264 -r 30 $filename
