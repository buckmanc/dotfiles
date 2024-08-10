#!/usr/bin/env bash

for f in ~/.vim/spell/*.add
do
	oldText="$(cat "$f")"
	newText="$(echo "$oldText" | ~/bin/pysort | uniq)"

	if [ "$oldText" != "$newText" ]
	then
		echo "$newText" > "$f"
	fi
done
