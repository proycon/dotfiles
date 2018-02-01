#!/bin/bash
brightness=$(cat /sys/class/backlight/intel_backlight/brightness)

if (($brightness > 0)); then
  let brightness=$brightness-100
  echo "echo $brightness > /sys/class/backlight/intel_backlight/brightness" | sudo zsh #or bash
fi
