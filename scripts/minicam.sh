#!/bin/sh
v4l2-ctl --set-fmt-video=width=320,height=240
mpv av://v4l2:/dev/video0
