#!/bin/bash

optClean=0
optSmudge=1
optTermux=0
if [[ "$1" == "--clean" ]]
then
	optClean=1
	optSmudge=0
fi

if [[ "$XENVIRO" == "mobile" || "$XENVIRO" == "termux" || "$HOME" == *"termux"* ]]
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

