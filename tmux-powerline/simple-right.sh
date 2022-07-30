#!/bin/sh
if [ -e ~/.light ]; then
    uptime | awk -F " " '{  print "#[fg=colour132,bg=colour231] ",$6,"#[default, bg=colour231] #[fg=colour167, bg=color231]",$10,$11,$12,"#[default, bg=colour231] #[fg=colour136, bg=colour231]",$1,"#[default]" }'
else
    uptime | awk -F " " '{  print "#[fg=colour132,bg=colour235] ",$6,"#[default, bg=colour235] #[fg=colour167, bg=colour235]",$10,$11,$12,"#[default, bg=colour235] #[fg=colour136, bg=colour235]",$1,"#[default]" }'
fi
