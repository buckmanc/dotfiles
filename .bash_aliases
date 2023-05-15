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

# no trailing whitespace
# remove whitespace from the end of files
notw(){
	# add pipe args to the list of regular args
	args="$@"
	[[ -p /dev/stdin ]] && { mapfile -t; set -- "${MAPFILE[@]}"; set -- "$@" "$args"; }

	sed -bi 's/[ \t]*\(\r\?\)$/\1/' "$@"

}

# set window title
title() { echo -ne "\e]0;$1\a"; }

figtest() {

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
