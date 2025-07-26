#!/bin/sh
swaymsg bar mode invisible
if sxmo_rotate.sh isrotated; then
	gst-launch-1.0 libcamerasrc camera-name="/base/soc@0/cci@ac4a000/i2c-bus@0/camera@10" name=cs src::stream-role=view-finder cs.src ! queue ! videoconvert ! gtkwaylandsink -e
else
	gst-launch-1.0 libcamerasrc camera-name="/base/soc@0/cci@ac4a000/i2c-bus@0/camera@10" name=cs src::stream-role=view-finder cs.src ! queue ! videoconvert ! gtkwaylandsink rotate-method=3 -e
fi
swaymsg bar mode dock
