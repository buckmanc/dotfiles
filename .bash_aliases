# TODO add cdx, to parse a dir from the last history command and cd to it

# aliases / functions starting with an x indicate a custom variant of a command, or a way of avoiding overwriting another command

alias unmount=umount
alias xtree='tree -fi | grep -i --color'
alias xgrep='grep -i --color'
alias xhistory='history | cut -c 8- | grep -ivE  "^x?hist(ory | )" | grep -i --color'
alias xhist='xhistory'
alias xschellcheck='xshellcheck'
alias gut='git'
alias got='git'
alias it='git'
alias tgi='git'
alias tgit='git'
alias ttgi='git'
alias sgit='git'
alias lgit='git'
alias mgit='git'
alias ugit='git'
alias vum='vim'
alias vom='vim'
alias vin='echo "praise the Ascendant Warrior" ; vim'
alias :q="echo \"this isn't vim, "'$("$HOME/bin/message-error-name")'"\""
alias :wq=":q"
alias :w=":q"
alias :x=":q"
alias x=":q"
alias ZZ=":q"
alias dc="cd"
# long exa
alias lexa='exa --long --no-permissions --no-user --icons --time-style long-iso'

# aliases for bin stuff
alias xleep='xsleep'
alias bookenberg='gutenbook'
alias screeny='xscreen'
alias xscr='xscreen'
alias xscrn='xscreen'

if [[ -d ~/.jpsxdec ]]
then
	alias jpsxdec='java -jar ~/.jpsxdec/jpsxdec.jar'
fi
if [[ -f ~/dropbox.py ]]
then
	alias dropbox='python3 ~/dropbox.py'
fi

# backwards compatibility for the old image magick convert command
if (type magick >/dev/null 2>&1)
then
	alias convert='magick convert'
fi

# this has to be a shell function
# scripts can't cd the user session
# aliases can't handle args
mkdircd(){
	# not sure I've got the terminology right here
	args=()
	options=()

	for arg in "$@"
	do
		if [[ "${arg:0:1}" == "-" ]]
		then
			options+=("$arg")
		else
			args+=("$arg")
		fi
	done

	if [[ ! -e "${args[0]}" ]]
	then
		mkdir "$@"
	fi

	if [[ -e "${args[0]}" ]]
	then
		cd "${args[@]}"
	fi
}

figtest() {

	if (! type figlet >/dev/null 2>&1)
	then
		echo 'figlet not installed'
		return 1
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
    [[ $((count % 10)) = 0 ]] && printf "\n"
done
printf "\n"
}

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

	if [[ $COLUMNS -gt 0 ]] && [[ $COLUMNS -lt 40 ]]
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

	if [[ "$optHelp" == 1 ]]
	then
		echo "$help"
		return 0
	fi

	buildFlags="--nologo --verbosity quiet -consoleLoggerParameters:NoSummary"

	# both is just default
	if [[ "$optWarnings" == 1 ]] && [[ "$optErrors" == 1 ]]
	then
		optWarnings=0
		optErrors=0
	fi
	
	# set what text to search for
	if [[ "$optWarnings" == 1 ]]
	then
		buildFlags="${buildFlags} -consoleLoggerParameters:WarningsOnly"
		errowarn="warning"
	elif [[ "$optErrors" == 1 ]]
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
	if [[ "$optShort" == 1 ]]
	then
		tableHideColumns="${tableHideColumns},file"
	fi
	if [[ "$optLong" -ne 1 ]] || [[ "$optShort" == 1 ]]
	then
		if [[ "$optWarnings" == 1 ]] || [[ "$optErrors" == 1 ]]
		then
			tableHideColumns="${tableHideColumns}, error num"
		else
			numTrim="perl -pe s/\s(erro|warn)(r|ing)\s\w+?\d+/\1/g"
		fi
	fi

	# truncate file names when the screen is small
	fileTrim="cat"
	# if [[ "$smallScreen" == 1 ]] && [[ "$optShort" == 0 ]] && [[ "$optLong" == 0 ]]
	if [[ "$smallScreen" == 1 ]] && [[ "$optShort" == 0 ]]
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
	if [[ "$optLong" -ne 1 ]]
	then
		text=$(echo "${text}" | cut -c-"$COLUMNS")
	fi

	if [[ "$optLong" == 1 ]] && [[ "$smallScreen" == 1 ]] && [[ "$optShort" == 0 ]]
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
	if [[ -z "$text" ]]
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
		if [[ -z "${shortCmd}" ]]
		then
			shortCmd="${cmd}"
		fi

		cmd="${cmd} --help"
	elif [[ -z "${shortCmd}" ]]
	then
		shortCmd=$(echo "${cmd}" | perl -pe 's/^(.+) --.+/\1/g')
	fi

	helpText="$($cmd)"

	options="$(echo "$helpText" | grep -Pio '(?<=[\s^|])\-\-[\w\-]+?(?=[\s<$,])')"
	verbs="$(echo "$helpText"| grep -Pio '(?<=^  )\w[\w\-]+?(?=  )')"

	# echo "input:    $@"
	# echo "cmd:      ${cmd}"
	# echo "shortCmd: ${shortCmd}"
	# echo "options:  ${options}"
	# echo "verbs:    ${verbs}"

	allArgs="$options"$'\n'"$verbs"

	output=$(echo "$allArgs" | sort | uniq | grep -iv '^$' | tr '\n' ' ' | perl -pe 's/[ \t]$//g')
	echo "complete -W \"${output}\" $shortCmd"

	# run this command on verbs, following the tree all the way down
	# this could easy get out of control
	# this works, but the syntax for "complete" is wrong; sub commands overwrite the higher commands somehow
	# TODO write some kind of dynamic function for these
	# echo "$verbs" | while read -r verb
	# do
	# 	# skip bupkiss
	# 	if [[ -z "$verb" ]]
	# 	then
	# 		continue
	# 	fi
        #
	# 	# echo "calling completeme from input '$@' on verb '$verb'"
        #
	# 	# explicit subshell is essential here
	# 	(completeme "$shortCmd $verb")
        #
	# done

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

	locPath="$HOME/.config/xwttrlocs"
	if [[ -n "$locPath" ]]
	then
		locText="$(cat "$locPath")"
		# take first field before comma
		locs="{$(echo "$locText" | cut -d, -f1 | perl -pe 's/\n/,/g' | perl -pe 's/,$//g' | perl -pe 's/,{2,}/,/g')}"
		aliasLines="$(echo "$locText" | grep ',')"

	else
		locs=''
		aliasLines=''
	fi
	if [[ $# -eq 0 ]]
	then
		results="$(timeout 5s bash -c "wttr '$locs' 'format=%l:~%t(%f)~%c%C\n'")"
		while read -r line
		do
			oldText="$(echo "$line" | cut -d, -f1)"
			newText="$(echo "$line" | cut -d, -f2)"
			results="$(echo "$results" | sed "s/$oldText/$newText/g")"

		done < <(echo "$aliasLines")
		degrees="$(echo "$results" | grep -iPo '°\w' | head -n 1)"

		echo "$results" | sed -e 's/ \{2,\}/ /g' -e 's/°[CF]//g' -e 's/\+//g' -e "s/)/) $degrees/g" | column --table --separator '~'

	elif [[ "$1" = "moon" ]]
	then
		timeout 5s bash -c "wttr $@"
	else
		timeout 5s bash -c "wttr '' $@"
	fi
}

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

quoter_update(){
	# store file paths, names in a dictionary format
	# try a json file, parse with jq
	# 'quoter todo "bake us a cake"' appends to the file
	# 'quoter todo' opens the file

	fileSearch="${1}"
	textToAdd="${2}"

	if [[ -z "${fileSearch}" ]]
	then
		blarp=blorp
		# list optional names
	fi

	# find file path
	# something like '^${fileSearch.*'
	# warn an exit if more than one matching path found

	if [[ -z "${textToAdd}" ]]
	then
		blarp=blorp
		# vim file
	else
		blarp=blorp
		# append to file
	fi
}


dotnewt(){

	if [[ $# -eq 0 ]]
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
