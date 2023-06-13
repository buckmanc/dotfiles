# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

goodbymessage()
{
	# very possible to hardcode messages here
	#messages[0]="goodnight"

	#size=${#messages[@]}
	#index=$(($RANDOM % $size))
	#message="${messages[$index]}"

	# pick a random line from the farewells file
	message="$(shuf -n 1 ~/.config/messages/farewells.txt)"
	# strip blank lines
	message=$(echo "$message" | sed "/^[[:space:]]*\?$/d")
	# strip comments
	message=$(echo "$message" | sed "/^#/d")
	# punctuate
	message=$(echo "$message" | sed "s/[^[:punct:]]$/&./")
	# capitalize
	message="${message^}"

	if type cowsay >/dev/null 2>&1; then
		message=$(cowsay "$message")
	fi
	if type lolcat >/dev/null 2>&1; then
		message=$(echo "$message" | lolcat --force)
	fi

	echo
	echo "$message"
}

clear
goodbymessage
sleep 1
