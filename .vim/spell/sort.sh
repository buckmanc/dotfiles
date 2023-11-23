#!/usr/bin/env bash

for f in ~/.vim/spell/*.add
do
	oldText="$(cat "$f")"
	newText="$(echo "$oldText" | ~/bin/pysort)"

	if [ "$oldText" != "$newText" ]
	then
		echo "$newText" > "$f"
	fi
done
