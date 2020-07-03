#!/bin/sh
DATE=$(date +%Y%m%d-%H%M%S)
media-ctl -d /dev/media1 --set-v4l2 '"ov5640 3-004c":0[fmt:UYVY8_2X8/1280x720]'
ffmpeg -s 1280x720 -f video4linux2 -i /dev/video1 -vframes 1 ~/Pictures/Photos/$DATE.jpg
