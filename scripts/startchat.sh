#!/bin/sh
pidof tg || foot --title tg tg &
pidof tut-mastodon || foot --title tut-mastodon tut-mastodon &
pidof fractal || fractal &
pidof senpai || foot --title senpai senpai-irc &
