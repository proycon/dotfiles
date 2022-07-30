#!/bin/sh
NOW=$(date +%H:%M:%S)
cat /proc/loadavg | awk -v "NOW=$NOW" -F " " '{  print "#[default, bg=colour235] #[fg=colour139, bg=colour235]",$1,"#[default, bg=colour235] #[fg=normal, bg=colour235]",NOW,"#[default]" }'
