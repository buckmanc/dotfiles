#!/usr/bin/env bash

fileordir(){
	if [[ -d "$1" || -f "$1" ]]
	then
		return 0
	else
		if [[ "$optTestOnly" == 1 ]]
			then
				echo "does not exist: $1" > "$(tty)"
		fi
		
		return 1
	fi
}

linkylink(){

	local source=$1
	local dest=$2
	local optCreateIfDoesntExist=$3
	local parentdestdir="$(dirname -- "$(readlink -f -- "$dest")")"
	if [ "${parentdestdir}" == "." ]
	then
		parentdestdir=""
	fi

	if [[ -z "$optCreateIfDoesntExist" ]]
	then
		optCreateIfDoesntExist=0
	fi

	if [[ "$source" -ef "$dest" ]]
	then
			if [[ "$optTestOnly" == 1 ]]
			then
				echo "source and dest are the same on this machine: $dest"
			fi
		return
	fi

	# echo "parent dest dir: ${parentdestdir}"

	if fileordir "${source}" && [[ -n "${dest}" ]] && [[ -d "${parentdestdir}" ]] && ( fileordir "${dest}" || [[ "${optCreateIfDoesntExist}" == 1 ]] )
	then
		# TODO warn if there's more than 10 files in this folder
		if fileordir "${dest}"
		then
			if [[ "$optTestOnly" != 1 ]]
			then
				rm -rf "${dest}"
			fi
		fi

		local junctionArg
		if [[ -d "$source" ]]
		then
			junctionArg="/J"
		fi

		# gotta use weird mklink syntax
		if [[ "$optTestOnly" == 1 ]]
		then
			echo "would have linked ${source} to ${dest}" > "$(tty)"
		else
			echo "attempting to link ${source} to ${dest}" > "$(tty)"
			cmd <<< "mklink ${junctionArg} \"${dest}\" \"${source}\""
		fi
	fi
}

optTestOnly=0
# optTestOnly=1

# have to use windows environment variables instead of $HOME
# so that windows can read the resulting symlinks
winHome="${HOMEDRIVE}${HOMEPATH}"

wtDest=$(find "${LOCALAPPDATA}/Packages/" -maxdepth 2 -wholename "*WindowsTerminal*" -name LocalState -print -quit)
firefoxDictPath=$(find "${APPDATA}/Mozilla/Firefox/Profiles" -name persdict.dat -print -quit)

# should be the same on *most* systems
linkylink "${winHome}/.config" "${USERPROFILE}/.config"

linkylink "${winHome}/.config/WindowsTerminal" "$wtDest"
# yes, I've had one machine with all four PowerShell paths
linkylink "${winHome}/.config/PowerShell" "${winHome}/Documents/PowerShell"
linkylink "${winHome}/.config/PowerShell" "${winHome}/My Documents/PowerShell"
linkylink "${winHome}/.config/PowerShell" "${winHome}/Documents/WindowsPowerShell"
linkylink "${winHome}/.config/PowerShell" "${winHome}/My Documents/WindowsPowerShell"

# custom spelling dictionary
linkylink "${winHome}/.vim/spell/external/spellfile_custom.txt" "${APPDATA}/Microsoft/UProof/CUSTOM.DIC" 1
linkylink "${winHome}/.vim/spell/external/spellfile_custom.txt" "${APPDATA}/Microsoft/Teams/Custom Dictionary.txt" 1
linkylink "${winHome}/.vim/spell/external/spellfile_custom.txt" "${APPDATA}/../Local/Google/Chrome/User Data/Default/Custom Dictionary.txt" 1
linkylink "${winHome}/.vim/spell/external/spellfile_custom.txt" "${APPDATA}/Notepad++/plugins/config/Hunspell/en_US.usr"
linkylink "${winHome}/.vim/spell/external/spellfile_custom.txt" "${firefoxDictPath}" 1

