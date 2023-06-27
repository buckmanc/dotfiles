# TODO add cdx, to parse a dir from the last history command and cd to it

# aliases / functions starting with an x indicate a custom variant of a command, or a way of avoiding overwriting another command

alias xtree='tree -fi | grep -i --color'
alias xgrep='grep -i --color'
alias xhistory='history | cut -c 8- | grep -ivE  ^x?history | grep -i --color'
alias gwap='git diff -w --no-color | git apply --cached --ignore-whitespace && git checkout -- . && git reset && git add -p'
alias screeny='screen -DRRqS screeny_weeny -L'

mkdircd() {
	mkdir "$1"
	cd "$1"
}

open() {
	# TODO vim -p these on other platforms
	if [ $OSTYPE != 'msys' ]
	then
		echo 'this function is only supported on windows'
		return -1
	fi

	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	# iterate over args
	for i in "$@"
	do
		# ignore empty args, which show up when using pipes for some reason
		if [[ -z $i ]]
		then
			continue
		fi

		# echo $i

		absolutepath=$(readlink -f "$i")
		foldername=$(dirname -- "$absolutepath")
		filename=$(basename -- "$i")

		# echo $filename

		(cd "$foldername" && explorer "$filename") # parenthesis so it doesn't change the user's directory
	done

	# return success
	return 0
}

# fix trailing whitespace
# remove whitespace from the end of files
fixtw(){
	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	sed -bi 's/[ \t]*\(\r\?\)$/\1/' "$@"

}
# add a space after //
# this isn't perfect and will require manual review, so do it on a clean repo
fixcomment(){
	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	sed -i "s#(\s+?////+?)([^\s//])#\1 \2#g" "$@"

}
fixtab(){

	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	# iterate over args
	for i in "$@"
	do
		text=`expand -i -t 4 "$i"`
		echo "$text" > "$i"

	done

	return 0
}

# set window title
title() { echo -ne "\e]0;$1\a"; }

figtest() {

	if (! type figlet >/dev/null 2>&1)
	then
		echo 'figlet not installed'
		return -1
	fi

	echo
	echo 'figlet fonts courtesy of figlist'
	echo

	# iterate over font names
	figlist | while read f
	do
		#echo f:\ $f
		figlet -l -f "$f" "$f" 2> /dev/null
	done

	echo
	echo 'figlet -f fontname text'

	# return success
	return 0
}

ls-chars() {
#stackoverflow.com/a/60475015/1995812

for range in $(fc-match --format='%{charset}\n' "$1"); do
    for n in $(seq "0x${range%-*}" "0x${range#*-}"); do
        printf "%04x\n" "$n"
    done
done | while read -r n_hex; do
    count=$((count + 1))
    printf "%-5s\U$n_hex\t" "$n_hex"
    [ $((count % 10)) = 0 ] && printf "\n"
done
printf "\n"
}

# long exa
alias lexa='exa --long --no-permissions --no-user --icons --time-style long-iso'
alias builderrors="dotnet clean > /dev/null && dotnet build | sort | uniq | sed 's#/#\\\\#g' | sed -E 's/^.+?\\\\(.+?: )/\1/g' | grep -iP 'error|warning' | grep -ivP '^\s+?[\d,]+? (error|warning)\(s\)$' | column -t --separator ':[' --table-columns 'file, error num, error message' --table-hide '-' | cut -c-\$COLUMNS | uniq"
# short build errors
alias sbuilderrors="dotnet clean > /dev/null && dotnet build | sort | uniq | sed 's#/#\\\\#g' | sed -E 's/^.+?\\\\(.+?: )/\1/g' | grep -iP 'error|warning' | grep -ivP '^\s+?[\d,]+? (error|warning)\(s\)$' | column -t --separator ':[' --table-columns 'file, error num, error message' --table-hide file,'-' | cut -c-\$COLUMNS | uniq"

xindent(){

	spaces=$(seq -s " " 0 "$1" | sed -E 's/[0-9]+?//g')
	while read -r; do
		echo "${REPLY}" | sed -E "s/^/${spaces}/g"
	done
}
center(){
	text=""
	i="0"
	while read -r; do
		if [ "$i" -ne 0 ]
		then
			text+="
"
		fi
		text+="${REPLY}"
		i=$((i+1))
	done

	longestLineLen=$(echo "${text}" | wc -L)

	if [ -z "$COLUMNS" ] || [ "$COLUMNS" -le 0 ]
	then
		echo "${text}"
		return 0
	elif [ "$longestLineLen" -ge "$COLUMNS" ]
	then
		echo "${text}"
		return 0
	fi

	spaces=$((($COLUMNS - $longestLineLen) / 2))


	echo "${text}" | xindent "${spaces}"

}

goodbyemessage()
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
	message=$(echo "${messages}" | shuf --random-source='/dev/urandom' -n 1)
	# punctuate
	message=$(echo "${message}" | sed "s/[^[:punct:]]$/&./")
	# capitalize
	message="${message^}"
	# wrap based on screen width
	targetWidth=$(($COLUMNS - 4))
	if [ "$targetWidth" -gt "0" ]
	then
		message=$(echo "${message}" | fmt -w "$targetWidth")
	fi

	if type cowsay >/dev/null 2>&1; then
		message=$(echo "${message}" | cowsay -n)
	fi

	message=$(echo "${message}" | center)

	if type lolcat >/dev/null 2>&1; then
		message=$(echo "${message}" | lolcat --force)
	fi

	echo
	echo "${message}"
	echo
}

shutdown() {
	# TODO expand OS checking into a user enviro variable or function
	# include cygwin as windows

	cowtime=2

	if [ $1 == 'now' ] && [ -z "$3" ]
	then
		if [ $OSTYPE == 'msys' ] && [ "$2" = "-r" ]
		then
			clear
			goodbyemessage
			sleep $cowtime 

			`which shutdown` -r -f -t 0

		elif [ $OSTYPE == 'msys' ] && [ -z "$2" ]
		then
			clear
			goodbyemessage
			sleep $cowtime

			`which shutdown` -s -hybrid -f -t 0

		elif [ -n "$SSH_CLIENT" ] && [ -z "$2" ]
		then

			#confirm if the user REALLY WANTS to shutdown this machine
			#is not called if a user does "sudo shutdown..."
			read -p "Are you sure you want to shutdown this remote machine?" -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]
			then
				sudo echo
				if [ $? -eq 0 ]
				then

					clear
					goodbyemessage
					sleep $cowtime

					sudo `which shutdown` $@
				fi
			fi
		elif [ -n "$SSH_CLIENT" ] && [ "$2" == "-r" ]
		then
			sudo echo
			if [ $? -eq 0 ]
			then

				clear
				goodbyemessage
				sleep $cowtime

				sudo `which shutdown` $@
			fi
		else
			`which shutdown` $@
		fi

		return "$?"

	# if not doing "shutdown now", just pass the args along, no special behaviour
	else
		`which shutdown` $@
	fi
}
export shutdown

winterm() {

	if (! type wt >/dev/null 2>&1)
	then
		echo 'windows terminal not installed'
		return -1
	fi

	wt nt --startingDirectory "$1"
}
