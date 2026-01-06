#!/usr/bin/env bash

# this is very tricky
# it fails when smudging itself, so a "clean only" filter is set in a folder specific .gitattributes
# when setting up termux a termux shebang will have to be manually added to this file
# termux documentation says you can use the standard env shebang
# but it doesn't work in all circumstances, like during login

optClean=0
optSmudge=1
optTermux=0

if [[ "$1" == "--clean" ]]
then
	optClean=1
	optSmudge=0
fi

if [[ "$OSTYPE" == "linux-android" || "$HOME" == *"termux"* ]]
then
	optTermux=1
fi

if [[ "$optSmudge" == 1 && "$optTermux" == 1 ]] 
then
	# to termux
	sed 's|^#!/usr/bin/env |#!/data/data/com.termux/files/usr/bin/|g'
elif [[ "$optClean" == 1 ]] || [[ "$optSmudge" == 1 && "$optTermux" == 0 ]]
then
	# away from termux
	sed 's|^#!/data/data/com.termux/files/usr/bin/|#!/usr/bin/env |g'
fi

