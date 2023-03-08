alias xtree='tree -fi | grep -i --color'
alias xgrep='grep -i --color'
alias xhistory='history | cut -c 8- | grep -ivE  ^x?history | grep -i --color'
alias gwap='git diff -w --no-color | git apply --cached --ignore-whitespace && git checkout -- . && git reset && git add -p'

mkdircd() {
	mkdir "$1"
	cd "$1"
}

open() {

	if [ $OSTYPE != 'mysys' ]
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

		echo $i

		absolutepath=$(readlink -f "$i")
		foldername=$(dirname -- "$absolutepath")
		filename=$(basename -- "$i")

		echo $filename

		(cd "$foldername" && explorer "$filename") # parenthesis so it doesn't change the user's directory
	done

	# return success
	return 0
}

