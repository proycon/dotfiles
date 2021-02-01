#!/bin/sh
printf '%x' \'$1 | xargs -I{} fc-list ":charset={}"

