#!/bin/sh
cd ~/.todo/
git commit -a -m "update"
. ~/.github_token.sh
todo.sh issue sync
git commit -a -m "github sync"
todo.sh notmuch
git commit -a -m "notmuch sync"
