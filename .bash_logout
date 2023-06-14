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

	# read farewells file
	messages="$(cat ~/.config/messages/farewells.txt)"
	# strip blank lines
	messages=$(echo "${messages}" | sed "/^[[:space:]]*\?$/d")
	# strip comments
	messages=$(echo "${messages}" | sed "/^#/d")
	# pick a random line from the farewells file
	message=$(echo "${messages}" | shuf -n 1)
	# punctuate
	message=$(echo "${message}" | sed "s/[^[:punct:]]$/&./")
	# capitalize
	message="${message^}"
	# wrap based on screen width
	message=$(echo "${message}" | fmt -w $(($COLUMNS - 4)))

	if type cowsay >/dev/null 2>&1; then
		message=$(echo "${message}" | cowsay -n)
	fi
	if type lolcat >/dev/null 2>&1; then
		message=$(echo "${message}" | lolcat --force)
	fi

	echo
	echo "${message}"
	echo
}

clear
goodbymessage
sleep 1
