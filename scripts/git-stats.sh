#!/bin/bash

# MIT License
# Source: https://git.sr.ht/~rjarry/aerc/tree/master/item/contrib/git-stats.sh

set -e
set -o pipefail

columns="Author,Commits,Changed Files,Insertions,Deletions"

git shortlog -sn "$@" |
while read -r commits author; do
	git log --author="$author" --pretty=tformat: --numstat "$@" | {
		adds=0
		subs=0
		files=0
		while read -r a s f; do
			[ "$a" = "-" ] && a=0
			[ "$s" = "-" ] && s=0
			adds=$((adds + a))
			subs=$((subs + s))
			files=$((files + 1))
		done
		printf '%s;%d;%d;%+d;%+d;\n' \
			"$author" "$commits" "$files" "$adds" "-$subs"
	}
done |
column -t -s ';' -N "$columns" -R "${columns#*,}" |
sed -r 's/[[:space:]]+$//'

echo

columns="Reviewer/Tester,Commits"

git shortlog -sn \
	--group=trailer:acked-by \
	--group=trailer:tested-by \
	--group=trailer:reviewed-by "$@" |
while read -r commits author; do
	printf '%s;%s\n' "$author" "$commits"
done |
column -t -s ';' -N "$columns" -R "${columns#*,}" |
sed -r 's/[[:space:]]+$//'
