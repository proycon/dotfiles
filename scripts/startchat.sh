#!/bin/sh
sleep 1
pidof telegram-desktop || telegram-desktop &
#pidof tg || foot --title tg tg &
#pidof tut-mastodon || foot --title tut-mastodon tut-mastodon &
pidof nheko || nheko &
pidof senpai || foot --title senpai senpai-irc &
