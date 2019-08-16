#!/bin/bash

while [[ -f screencast$n.mpeg ]]
do
	n=$((n+1))
done
filename="screencast$n.mpeg"
echo $filename

ffmpeg -y \
-f x11grab \
-s $(xdpyinfo | grep dimensions | awk '{print $2;}') \
-i :0.0 \
-r 25 $filename

#-vf scale=1920:1080 \
#ffmpeg -i Untitled_Screencast.webm -r 1 -pix_fmt rgb24 out.gif
