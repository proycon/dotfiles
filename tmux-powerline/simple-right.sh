#!/bin/sh
uptime | awk -F " " '{  print "#[fg=colour132,bg=colour239] ",$6,"#[default, bg=colour239] #[fg=colour139, bg=colour239]",$10,$11,$12,"#[default, bg=colour239] #[fg=normal, bg=colour239]",$1,"#[default]" }'
