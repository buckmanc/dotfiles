#!/usr/bin/env bash

# this git filter script standardizes terminal wallpaper settings to a default when git looks at them
# this allows for wallpaper shuffling without dirtying the repo
# windows terminal and xfce terminal supported at present

input="$(cat)"
if [[ "${input::1}" == "{" ]]
then
	input="$(echo "$input" | "$HOME/bin/sort-json")"
fi
winDefaultPath="%HOMEDRIVE%%HOMEPATH%\.config\\assets\\backgrounds\\totk_ouroboros_grey.png"
xfceDefaultPath=".config/assets/backgrounds/totk_ouroboros_grey.png"
linDefaultPath="$HOME/$xfceDefaultPath"
# escape once for windows terminal and once for the perl command below
wtPath="$(echo "$winDefaultPath" | sed -e 's/\\/\\\\/g' -e 's/\\/\\\\/g')"

if type perl >/dev/null 2>&1
then
	echo "$input" | \
		perl -Xpe "s|(?<=^\s{1,50}\"backgroundImage\": ?\")[^\"]+(?=\",?$)|$wtPath|g" | \
		perl -Xpe "s|(?<=^BackgroundImageFile=).+$|$xfceDefaultPath|g"
else
	echo "$input"
fi
