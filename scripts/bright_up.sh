#!/bin/bash
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
brightness=$(cat /sys/class/backlight/intel_backlight/brightness)

if (($brightness < $max_brightness)); then
  let brightness=$brightness+100
  echo "echo $brightness > /sys/class/backlight/intel_backlight/brightness" | sudo zsh #or bash
fi
