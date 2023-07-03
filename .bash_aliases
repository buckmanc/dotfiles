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
		if [[ -f "$absolutepath" ]]
		then
			foldername=$(dirname -- "$absolutepath")
			filename=$(basename -- "$i")
		else
			foldername="$absolutepath"
			filename="."
		fi

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

	path=$(readlink -f "$1")

	wt nt --startingDirectory "$path"
}
# start wttr.in/:bash.function
# If you source this file, it will set WTTR_PARAMS as well as show weather.

# WTTR_PARAMS is space-separated URL parameters, many of which are single characters that can be
# lumped together. For example, "F q m" behaves the same as "Fqm".
if [[ -z "$WTTR_PARAMS" ]]; then
  # Form localized URL parameters for curl
  if [[ -t 1 ]] && [[ "$(tput cols)" -lt 125 ]]; then
      WTTR_PARAMS+='n'
  fi 2> /dev/null
  for _token in $( locale LC_MEASUREMENT ); do
    case $_token in
      1) WTTR_PARAMS+='m' ;;
      2) WTTR_PARAMS+='u' ;;
    esac
  done 2> /dev/null
  unset _token
  export WTTR_PARAMS
fi

wttr() {
  local location="${1// /+}"
  command shift
  local args=""
  for p in $WTTR_PARAMS "$@"; do
    args+=" --data-urlencode $p "
  done
  curl -fGsS -H "Accept-Language: ${LANG%_*}" $args --compressed "wttr.in/${location}"
}

# end wttr.in/:bash.function

# position of moonphase glyphs correspond to the day of the moon
export MOONPHASE_NERDFONT_GLYPHS=""

nerdmoon(){
	# moon phases in nerdfont glyphs

	url="wttr.in/?format=%M"
	moonday=$(curl -s "${url}")

	logPath="${HOME}/.logs/nerdmoon_to_$(date -Iseconds).txt"
	echo "url:      ${url}" >> "${logPath}"
	echo "response: ${moonday}" >> "${logPath}"

	# zero base our moonday
	moonday=$(($moonday-1))

	output=${MOONPHASE_NERDFONT_GLYPHS:$moonday:1}

	echo "${output}"
	echo "output:   ${output}" >> "${logPath}"

}

# schedule me in cron
# or you can call immediately after definition to update when loading bash
nerdmoon_to_starship(){

	glyph="$(nerdmoon)"

	# replace any glyph from our chosen set of moon phase glyphs with the current moon phase glyph
	sed -i "s/[${MOONPHASE_NERDFONT_GLYPHS}]/${glyph}/g" ~/.config/starship.toml
}
# nerdmoon_to_starship

gutenbook(){

	# options
	# an oldie but a voldie
	# -v open file in vim (allows for saving progress if you open the file directly)
	# -o print the og, unaltered book
	# -l list matches from the catalog
	# -d list debug vars; urls, ids, paths

	# TODO -p to print path
	# TODO -h
	# TODO -e to dl epub?

	optVim=0
	optOG=0
	optList=0
	optDebug=0
	query=''

	for i in "$@"; do
		if [[ "$i" =~ ^-.*v ]]
		then
			optVim=1
		fi

		if [[ "$i" =~ ^-.*o ]]
		then
			optOG=1

		fi

		if [[ "$i" =~ ^-.*l ]]
		then
			optList=1
		fi

		if [[ "$i" =~ ^-.*d ]]
		then
			optDebug=1
		fi

		if [[ "$i" =~ ^[^-] ]]
		then
			query="$i"
		fi
	done

	# printallvars | grep ^opt

	if [ -z "${query}" ]
	then
		echo "please provide a book string to search for. regex works fine"
		return 1
	fi

	# caching a lot as gutenberg blocks aggressively

	cacheDir="$HOME/.cache/gutenbook"
	csvPath="${cacheDir}/gutenberg_catalog.csv"
	catalogURI="https://www.gutenberg.org/cache/epub/feeds/pg_catalog.csv"

	# if [ "${optDebug}" ]
	# then
	# 	echo
	# fi

	# download the csv catalog if it's newer or not yet saved
	if [ ! -f "$csvPath" ]
	then
		curl --create-dirs --location --compressed --max-time 30 --silent -o "${csvPath}" "${catalogURI}"
	else
		curl --create-dirs --location --compressed --max-time 30 --silent -o "${csvPath}" -z "${csvPath}" "${catalogURI}"
	fi

	# read the file, ignoring anything that isn't formatted correctly and labelled "text"
	# as of now this is only 1) the "Sound" category and 2) CSV error lines
	# the perl regex replaces new lines that are in a field with spaces
	csvText=$(cat "$csvPath" | perl -00pe 's/\r?\n(\D)/ \1/g' | grep -iP '^\d+,Text,')

	# list matches, highlighting ID and matches
	# TODO got some duplicate code here
	if [ "${optList}" == 1 ]
	then
		echo "${csvText}" | grep -iP "${query}" | grep -iP --color "^\d+|${query}"
		return 0
	fi

	# only nab the first match
	bookID=$(echo "${csvText}" | grep -iP "${query}" | grep -iPo "^\d+" | head -n 1)
	bookPath="${cacheDir}/${bookID}.txt"
	bookOgPath="${cacheDir}/${bookID}_og.txt"
	bookURI="https://www.gutenberg.org/ebooks/${bookID}.txt.utf-8"

	if [ -z "${bookID}" ]
	then
		echo "could not find ${query}"
		return 1
	fi

	# ( set -o posix ; set ) | xgrep book

	# download the book if it's not yet saved
	if [ ! -f "${bookPath}" ]
	then
		# check for http errors first
		httpStatus=$(curl -ILs "${bookURI}" -w "%{http_code}" | tail -n 1)
		if [[ "${httpStatus}" == "404" ]]
		then
			echo "bad book url"
			return 1
		elif [[ "${httpStatus}" != "200" ]]
		then
			echo "there was an http problem while fetching the book. http status: ${httpStatus}"
			return 1
		fi

		# grab the book
		bookText=$(curl --create-dirs --location --compressed --silent --max-time 30 "${bookURI}")

		# don't write that book on failure
		if [ -z "${bookText}" ]
		then
			echo "something went wrong"
			return 1
		elif [[ "${bookText}" =~ ^\<\!DOCTYPE ]]
		then
			echo "got a web page instead of a book"
			return 1
		fi

		echo "${bookText}" > "${bookOgPath}"

		startLine=$(echo "${bookText}" | grep -Pin -m1 '\s*?\*\*\*\s*?start( \w+)?( \w+)? project gutenberg' | cut -f1 -d:)
		if [ -n "${startLine}" ]
		then
			# echo "startLine: ${startLine}"
    			startLine=$((startLine + 1))
			bookText=$(echo "${bookText}" | tail -n +$startLine)
		fi

		endLine=$(echo "${bookText}" | grep -Pin -m1 '\s*?\*\*\*\s*?end( \w+)?( \w+)? project gutenberg' | cut -f1 -d:)
		if [ -n "${endLine}" ]
		then
			# echo "endLine: ${startLine}"
			endLine=$((endLine - 1))
			bookText=$(echo "${bookText}" | head -n +$endLine)
		fi

		# unwrap the hardwrapping
		# replace solitary newlines that aren't followed by a space
		bookText=$(echo "${bookText}" | dos2unix | perl -00pe 's/(?<!\n)\n(?![\n\s])/ /g')
		
		echo "${bookText}" > "${bookPath}"
	fi

	if [ "${optOG}" == 1 ]
	then
		outPath="${bookOgPath}"
	else
		outPath="${bookPath}"
	fi

	if [ "${optDebug}" == 1 ]
	then
		echo -n "book stats: "
		cat "${outPath}" | wc
	fi

	# serve up the book!
	if [ "${optVim}" == 1 ]
	then
		vim "${outPath}" 
	elif [ "${optDebug}" == 0 ]
	then
		cat "${outPath}" 
	elif [ "${optPrintPath}" == 0 ]
	then
		echo "${outPath}" 
	fi
	
}
alias bookenberg='gutenbook'

printallvars(){
	set -o posix; set | sort
}

squish(){
	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	echo "$@" | perl -00pe 's/[\r\n\s]+/ /g' | perl -00pe 's/^ //g' | perl -00pe 's/ $//g'
	echo # end with a new line
}
