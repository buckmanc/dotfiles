# TODO add cdx, to parse a dir from the last history command and cd to it

# aliases / functions starting with an x indicate a custom variant of a command, or a way of avoiding overwriting another command

alias xtree='tree -fi | grep -i --color'
alias xgrep='grep -i --color'
alias xhistory='history | cut -c 8- | grep -ivE  "^x?hist(ory | )" | grep -i --color'
alias xhist='xhistory'
alias gwap='git diff -w --no-color | git apply --cached --ignore-whitespace && git checkout -- . && git reset && git add -p'
alias gut='git'
if [ -d ~/.jpsxdec ]
then
	alias jpsxdec='java -jar ~/.jpsxdec/jpsxdec.jar'
fi
if [ -f ~/dropbox.py ]
then
	alias dropbox='python3 ~/dropbox.py'
fi

screeny() {
	name=$1
	if [ -z "$name" ]
	then
		name="screeny_weeny"
	fi

	if [ -z "$2" ]
	then
		screen -DRRqS "$name" -L
	fi
}
 
if [ -f /usr/share/bash-completion/completions/screen ]
then
	source /usr/share/bash-completion/completions/screen
fi
# https://superuser.com/a/947240
function _complete_screeny() {
	local does_screen_exist=$(type -t _screen_sessions)
	local cur=$2 # Needed by _screen_sessions
	if [[ "function" = "${does_screen_exist}" ]]; then
		# _screen_sessions "Detached"
		_screen_sessions
	fi
}
export -f _complete_screeny
complete -F _complete_screeny -o default screeny

mkdircd() {
	mkdir "$1"
	cd "$1"
}

open() {
	if [ -n "$SSH_CLIENT" ] && ( type vim >/dev/null 2>&1)
	then
		# TODO make vim open in tabs with -p instead of making multiple calls
		# try adding all found paths to a var
		# then running that var through xargs -o to openy program
		openy=vim
	elif ( type explorer >/dev/null 2>&1)
	then
		openy=explorer
	elif ( type xdg-open >/dev/null 2>&1)
	then
		openy=xdg-open
	else
		echo 'cannot find a program to open with'
		return -1
	fi

	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	log=()

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

		# if the file doesn't exist try again removing everything after :
		# makes this function play nice with grep results
		if [[ ! -f "${absolutepath}" ]]
		then
			absolutepath=$(echo "${absolutepath}" | grep -iPo '^.{2}[^:]+')
		fi

		# skip dupes
		# makes this function play nice with grep results
		if [[ " ${log[*]} " =~ " ${absolutepath} " ]]
		then
			continue
		fi

		if [[ -f "$absolutepath" ]]
		then
			foldername=$(dirname -- "$absolutepath")
			filename=$(basename -- "$absolutepath")
		elif [[ -d "$absolutepath" ]]
		then
			foldername="$absolutepath"
			filename="."
		else
			echo "could not find ${absolutepath}"
			continue
		fi

		# echo $filename

		(cd "$foldername" && $openy "$filename") # parenthesis so it doesn't change the user's directory

		log+=("${absolutepath}")
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

	# iterate over args
	for i in "$@"
	do
		# ignore empty args, which show up when using pipes for some reason
		if [[ -z $i ]]
		then
			continue
		fi

		sed -bi 's/[ \t]*\(\r\?\)$/\1/' "$i"
	done
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

fixcarriagereturn(){


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

		perl -i -pe 's/\r//g' "$i"
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

builderrors(){
	
help="Usage: $FUNCNAME [OPTION] [PATH]

Run dotnet clean and build with concise, parsed, one-line warning and error messages.

Options:
	-s short output
	-l long output
	-e errors only
	-w warnings only

	-h  show this help text
"
	optShort=0
	optLong=0
	optWarnings=0
	optErrors=0
	smallScreen=0
	path='.'

	if [ $COLUMNS -gt 0 ] && [ $COLUMNS -lt 40 ]
	then
		smallScreen=1
	fi
	
	for i in "$@"; do
		if [[ "$i" =~ ^-.*s ]]
		then
			optShort=1
		fi

		if [[ "$i" =~ ^-.*l ]]
		then
			optLong=1

		fi

		if [[ "$i" =~ ^-.*w ]]
		then
			optWarnings=1
		fi

		if [[ "$i" =~ ^-.*e ]]
		then
			optErrors=1
		fi

		if [[ "$i" =~ ^-.*h ]]
		then
			optHelp=1
		fi

		if [[ "$i" =~ ^[^-] ]]
		then
			path="$i"
		fi
	done

	if [ "$optHelp" == 1 ]
	then
		echo "$help"
		return 0
	fi

	buildFlags="--nologo --verbosity quiet -consoleLoggerParameters:NoSummary"

	# both is just default
	if [ "$optWarnings" == 1 ] && [ "$optErrors" == 1 ]
	then
		optWarnings=0
		optErrors=0
	fi
	
	# set what text to search for
	if [ "$optWarnings" == 1 ]
	then
		buildFlags="${buildFlags} -consoleLoggerParameters:WarningsOnly"
		errowarn="warning"
	elif [ "$optErrors" == 1 ]
	then
		buildFlags="${buildFlags} -consoleLoggerParameters:ErrorsOnly"
		errowarn="error"
	else
		errowarn="warning|error"
	fi

	# only show error numbers in long mode
	# hide columns as appropro
	numTrim="cat"
	# hide all dangling columns
	tableHideColumns="-"
	if [ "$optShort" == 1 ]
	then
		tableHideColumns="${tableHideColumns},file"
	fi
	if [ "$optLong" -ne 1 ] || [ "$optShort" == 1 ]
	then
		if [ "$optWarnings" == 1 ] || [ "$optErrors" == 1 ]
		then
			tableHideColumns="${tableHideColumns}, error num"
		else
			numTrim="perl -pe s/\s(erro|warn)(r|ing)\s\w+?\d+/\1/g"
		fi
	fi

	# truncate file names when the screen is small
	fileTrim="cat"
	# if [ "$smallScreen" == 1 ] && [ "$optShort" == 0 ] && [ "$optLong" == 0 ]
	if [ "$smallScreen" == 1 ] && [ "$optShort" == 0 ]
	then
		fileTrim="perl -pe s/^([\.\w]{7})[\.\w]{3,}/\1\.\.\./g"
	fi

	# clean, ignore output
	dotnet clean > /dev/null
	# build and parse only relevant error and warning data points into a table
	text=$(dotnet build $buildFlags | sort | uniq | \
		perl -pe 's/^\w:(?=[\/\\])//g' |  sed 's#[/\\]#\\\\#g' | sed -E 's/^.+?\\\\(.+?: )/\1/g' |  \
		tac -r -s 'x\|[^x]' | perl -pe 's/(?=([^:]*:){3}):/zzzzzzzzz/g' | tac -r -s 'x\|[^x]' | \
		$fileTrim | perl -pe 's/(Argument \d{1,2}):/\1/g' | \
		column -t --separator ':[' --table-columns 'file, error num, error message' -o ' ' --table-hide "$tableHideColumns" | \
		perl -pe 's/zzzzzzzzz/:/g' | \
		$numTrim)

	# unless in long mode, don't wrap 
	if [ "$optLong" -ne 1 ]
	then
		text=$(echo "${text}" | cut -c-"$COLUMNS")
	fi

	if [ "$optLong" == 1 ] && [ "$smallScreen" == 1 ] && [ "$optShort" == 0 ]
	then
		# regex some nicer formatting
		text=$(echo "${text}" | perl -pe 's/(\(\d+,\d+\)\s+(?:erro(?:r?)|warn(?:ing)?) \w+?\d+)\s+/\1 \2\n/g')
	else
		# sort but ignore the header
		text=$(echo "${text}" | (sed -u 1q; sort))
	fi

	# trim
	text=$(echo "${text}" | perl -pe 's/^[^\S\r\n]//g')

	# don't return an error if nothing was found
	if [ -z "$text" ]
	then
		return 0
	fi

	# highlight start and error/warning
	# important to have ^ in isolation or lines get stripped if nothing matches
	# having grep be the final command makes auto coloring work
	echo -n "${text}" | uniq | grep --color -P "^\w+\.{0,3}\w*(?=\(\d+,\d)|\serro(r)?\s|^erro(r)?\s|\swarn(ing)?\s|^warn(ing)?\s|^"

}

# stub for complete anything
# curl --help all | grep -Pio '(?<=[\s^])\-\-[\w\-]+?(?=[\s<$])' | tr '\n' ' '
# use output to write a script with a bunch of complete -W statements
# do that as a background job
#	 in a separate function, eval anything in the .cache/completions folder

completeme(){

	# optShort is probably useless, but leaving for now
	cmd=''
	shortCmd=''
	optShort=0
	for i in "$@"; do
		if [[ "$i" =~ ^-.*s ]]
		then
			optShort=1
		fi

		if [[ "$i" =~ ^[^-] ]]
		then
			if [[ -z "${cmd}" ]]
		then
			cmd="${i/\~/$HOME}"
		elif [[ -z "${shortCmd}" ]]
		then
			shortCmd="${i/\~/$HOME}"

			fi
		fi
	done

	if [[ "${cmd}" != *"--"* ]]
	then
		if [ -z "${shortCmd}" ]
		then
			shortCmd="${cmd}"
		fi

		cmd="${cmd} --help"
	elif [ -z "${shortCmd}" ]
	then
		shortCmd=$(echo "${cmd}" | perl -pe 's/^(.+) --.+/\1/g')
	fi

	# echo "cmd:      ${cmd}"
	# echo "shortCmd: ${shortCmd}"

	output=$($cmd | grep -Pio '(?<=[\s^])\-\-[\w\-]+?(?=[\s<$,])' | sort | uniq | tr '\n' ' ' | perl -pe 's/[ \t]$//g')
	echo "complete -W \"${output}\" $shortCmd"

}

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
		
		#confirm if the user REALLY WANTS to shutdown this machine
		if [ -n "$SSH_CLIENT" ] && [ -z "$2" ]
		then
			read -p "Are you sure you want to shutdown this remote machine?" -n 1 -r
			if [[ $REPLY =~ ^[^Yy]$ ]]
			then
				return 0
			fi
		fi

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

			# -hybrid not supported on some platforms
			`which shutdown` -s -hybrid -f -t 0 || `which shutdown` -s -f -t 0

		elif [ $OSTYPE == 'linux-gnu' ] && ( [ -z "$2" ] || [ "$2" == "-r" ] )
		then

			# if we have shutdown perms, don't ask for sudo
			if test -w $(which shutdown)
			then
				clear
				goodbyemessage
				sleep $cowtime

				`which shutdown` $@

			# if we don't have shutdown perms, check for sudo first
			else
				sudo echo
				if [ $? -eq 0 ]
				then

					clear
					goodbyemessage
					sleep $cowtime

					sudo `which shutdown` $@
				fi
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

export -f wttr

xwttr(){

	if [ $# -eq 0 ]
	then
		timeout 5s bash -c "wttr '' 'format=""+%c+%t""'"
	elif [ "$1" = "moon" ]
	then
		timeout 5s bash -c "wttr $@"
	else
		timeout 5s bash -c "wttr '' $@"
	fi
}


# position of moonphase glyphs correspond to the day of the moon
export MOONPHASE_NERDFONT_GLYPHS=""

nerdmoon(){
	# moon phases in nerdfont glyphs

	url="wttr.in/?format=%M"
	moonday=$(curl -s "${url}")

	logPath="${HOME}/.logs/nerdmoon/$(date -Iseconds).txt"
	mkdir -p "${HOME}/.logs/nerdmoon/"
	echo "url:      ${url}" >> "${logPath}"
	echo "response: ${moonday}" >> "${logPath}"

	# this should really be a loop but alas, here we are
	if [ -z "${moonday}" ]
	then
		sleep 10s
		moonday=$(curl -s "${url}")
		echo "response: ${moonday}" >> "${logPath}"
	fi

	if [ -z "${moonday}" ]
	then
		return 1
	fi

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

	if [ -z "${glyph}" ]
	then
		return 1
	fi

	# replace any glyph from our chosen set of moon phase glyphs with the current moon phase glyph
	sed -i "s/[${MOONPHASE_NERDFONT_GLYPHS}]/${glyph}/g" ~/.config/starship.toml
}
# nerdmoon_to_starship

gutenbook(){

# help="Usage: $(basename "$0") [OPTION] PATTERN
help="Usage: $FUNCNAME [OPTION] PATTERN

Search for books from Project Gutenberg! And cache aggressively to avoid being blocked.

Options:
	-v open file in vim (allows for saving progress if you open the file directly)
	-o print the og, unaltered book
	-l list matches from the catalog
	-d list debug vars; urls, ids, paths

	-h  show this help text
"
	# TODO -e epub
	optVim=0
	optOG=0
	optList=0
	optDebug=0
	optEpub=0
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

		if [[ "$i" =~ ^-.*h ]]
		then
			optHelp=1
		fi

		if [[ "$i" =~ ^-.*e ]]
		then
			optEpub=1
		fi

		if [[ "$i" =~ ^[^-] ]]
		then
			query="$i"
		fi
	done

	# printallvars | grep ^opt

	if [ -z "${query}" ] || [ "$optHelp" == 1 ]
	then
		echo "$help"
		return 0
	fi

	cacheDir="$HOME/.cache/gutenbook"
	csvPath="${cacheDir}/gutenberg_catalog.csv"
	catalogURI="https://www.gutenberg.org/cache/epub/feeds/pg_catalog.csv"

	if [ "${optDebug}" == 1 ]
	then
		echo "cacheDir:   ${cacheDir}"
		echo "csvPath:    ${csvPath}"
		echo "catalogURI: ${catalogURI}"
	fi

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
	bookPageURI="https://www.gutenberg.org/ebooks/${bookID}"
	bookURI="https://www.gutenberg.org/ebooks/${bookID}.txt.utf-8"
	
	if [ "${optDebug}" == 1 ]
	then
		echo "bookID:     ${bookID}"
		echo "bookPath:   ${bookPath}"
		echo "bookOgPath: ${bookOgPath}"
		echo "bookURI:    ${bookURI}"
		echo "bookPageURI:${bookPageURI}"
	fi

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
	# serve up the book!
	elif [ "${optVim}" == 1 ]
	then
		vim "${outPath}" +"set nospell"
	else
		cat "${outPath}" 
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

gowebgo(){
	local port=8080
	local dir="."
	local nextIsPort=0
	local nextIsDir=0

	for i in "$@"; do
		if [[ "$i" =~ ^-.*p ]]
		then
			nextIsPort=1

		elif [[ "$i" =~ ^-.*d ]]
		then
			nextIsDir=1
		fi
	done

# TODO arg support for port and dir
	sudo python -m http.server -d "${dir}" "${port}"
}

xsleep(){
	# use regex replace to support sleep syntax
	# 1s, 1h, 1m, 1d etc
	local input=$(echo "$*" \
		| perl -pe 's/(\d)+s( |$)/\1second/g' \
		| perl -pe 's/(\d)+m( |$)/\1minute/g' \
		| perl -pe 's/(\d)+h( |$)/\1hour/g' \
		| perl -pe 's/(\d)+d( |$)/\1day/g' \
		| perl -pe 's/(\d)+d( |$)/\1week/g' \
	)

	local startEpochSec=$(date +"%s")
	local targetEpochSec=$(date --date="$input" +"%s")
	local secToWait="$(($targetEpochSec-$startEpochSec))"
	echo "sleeping til $(date --date=@$targetEpochSec --rfc-3339=second | cut -c -19)"

	sleep "$secToWait"

	# TODO make this a countdown instead
	# while [ "$targetEpochSec" > $(date +"%s") ]
	# do
	# 	echo ""
	# 	sleep 1s
	# done
}
alias xleep='xsleep'

xrsync() {
    rsync -Przzu "$1"/* "$2"
    rsync -Przzu "$2"/* "$1"
}

superreplace(){
	local gitRoot=$(git rev-parse --show-toplevel)
	git ls-files | while read oldShortPath
	do
		local newShortPath=$(echo "${oldShortPath}" | sed -e "s/${1}/${2}/g" -e "s/${1,}/${2,}/g" -e "s/${1,,}/${2,,}/g")
		local oldFullPath="${gitRoot}/${oldShortPath}"
		local newFullPath="${gitRoot}/${newShortPath}"

		sed -i -e "s/${1}/${2}/g" -e "s/${1,}/${2,}/g" -e "s/${1,,}/${2,,}/g" "${oldFullPath}"
		if [[ ! "${oldFullPath}" -ef "${newFullPath}" ]]
		then
			# git mv "${oldFullPath}" "${newFullPath}"
			mv "${oldFullPath}" "${newFullPath}"
		fi

	done


}

dotnewt(){

	if [ $# -eq 0 ]
	then
		>&2 echo "You've gotta at least provide a template name"
		return 1
	fi

	read -p "Create a new dotnet $1 project in the current directory?" -n 1 -r
	if [[ $REPLY =~ ^[^Yy]$ ]]
	then
		return 0
	fi

	if ! dotnet new "$@" -o .
	then
		return 1
	fi

	dotnet new sln
	dotnet sln add *.csproj
	dotnet new gitignore
	git init
	git add .

	read -p "Initial commit?" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		git commit -m "Initial commit based on $1 dotnet template"
	fi
}
