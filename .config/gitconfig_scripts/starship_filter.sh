#!/bin/bash

hostnameText="$(hostname)"
# if [[ "$hostnameText" == "localhost" ]]
# then
#	aliasText="${hostnameText:0:3}"
# else
# 	aliasText="${hostnameText:0:1}"
# fi
#
aliasText="${hostnameText:0:3}"
safeString="\"{hostname}\" = \"{x}\""
unsafeString="\"$hostnameText\" = \"$aliasText\""
unsafeRegex="\"$hostnameText\" = \"\w{1,3}\""

optClean=0
optSmudge=1
if [[ "$1" == "--clean" ]]
then
	optClean=1
	optSmudge=0
fi

if [[ "$optSmudge" == 1 ]]
then
	sed -b -e "s/$safeString/$unsafeString/g"
elif [[ "$optClean" == 1 ]]
then
	# standardize nerdfont moon glyphs
	# support #gitignore
	# sanitize hostname alias
	sed -b -E "s/$unsafeRegex/$safeString/g" | sed -b -e 's/[]//g' -e '/#gitignore$/d'
fi

