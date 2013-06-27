#!/bin/sh
uptime | awk -F " " '{ print $6,"❮ ",$10,$11,$12," ❮#[fg=colour136, bg=colour235]",$1,"#[default]" }'
