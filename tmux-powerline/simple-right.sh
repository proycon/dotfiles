#!/bin/sh
uptime | awk -F " " '{  print "#[fg=colour132]",$6,"#[default, bg=colour235] ❮ #[fg=colour167, bg=colour235]",$10,$11,$12,"#[default, bg=colour235] ❮#[fg=colour136, bg=colour235]",$1,"#[default]" }'
