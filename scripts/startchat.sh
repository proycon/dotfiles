#!/bin/sh
sleep 1
export GTK_THEME=Adwaita-dark
pidof senpai || foot --title senpai senpai &
pidof telegram-desktop || telegram-desktop &
#pidof tg || foot --title tg tg &
#pidof tut-mastodon || foot --title tut-mastodon tut-mastodon &
if [ "$HOST" = "pollux" ]; then
    pidof scli || foot --title scli scli &
fi
pidof dino || dino &
pidof nheko || nheko &
