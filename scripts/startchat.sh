#!/bin/sh
pidof tg || foot --title tg tg &
pidof tut-mastodon || foot --title tut-mastodon tut-mastodon &
pidof gomuks || foot --title gomuks gomuks &
pidof senpai || foot --title senpai senpai-irc &
