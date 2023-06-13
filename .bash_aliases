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

alias lexa='exa --long --no-permissions --no-user --icons --time-style long-iso'
alias builderrors="dotnet build | sort | uniq | sed 's#/#\\\\#g' | sed -E 's/^.+?\\\\(.+?: )/\1/g' | grep -iP 'error|warning' | grep -ivP '^\s+?[\d,]+? (error|warning)\(s\)$' | column -t --separator ':[' --table-columns 'file,error num, error message' | cut -c-$COLUMNS | uniq"
alias sbuilderrors="dotnet build | sort | uniq | sed 's#/#\\\\#g' | sed -E 's/^.+?\\\\(.+?: )/\1/g' | grep -iP 'error|warning' | grep -ivP '^\s+?[\d,]+? (error|warning)\(s\)$' | column -t --separator ':[' --table-columns 'file,error num, error message' --table-hide file | cut -c-$COLUMNS | uniq"
