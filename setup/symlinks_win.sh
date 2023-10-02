#!/usr/bin/env bash

fileordir(){
	if [[ -d "$1" || -f "$1" ]]
	then
		return 0
	else
		if [[ "$optTestOnly" == 1 ]]
			then
				echo "does not exist: $1" > $(tty)
		fi
		
		return 1
	fi
}

linkylink(){

	local source=$1
	local dest=$2
	local optCreateIfDoesntExist=$3
	local parentdestdir="$(dirname -- "$(readlink -f -- "$dest")")"

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

	if fileordir "${source}" && [[ -d "${parentdestdir}" ]] && ( fileordir "${dest}" || [[ "${optCreateIfDoesntExist}" == 1 ]] )
	then
		# TODO warn if there's more than 10 files in this folder
		if fileordir "${dest}"
		then
			if [[ "$optTestOnly" == 1 ]]
			then
				echo "would have deleted ${dest} prior to symlink" > $(tty)
			else
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
			echo "would have linked ${source} to ${dest}" > $(tty)
		else
			cmd <<< "mklink ${junctionArg} \"${dest}\" \"${source}\""
		fi
	elif [[ "$optTestOnly" == 1 ]]
	then
		echo "nopers" > $(tty)
	fi
}

optTestOnly=0
optTestOnly=1

wtDest=$(find "${LOCALAPPDATA}/Packages/" -maxdepth 2 -wholename "*WindowsTerminal*" -name LocalState -print -quit)
firefoxDictPath=$(find "${APPDATA}/Mozilla/Firefox/Profiles" -name persdict.dat -print -quit)

# should be the same on *most* systems
linkylink "${HOME}/.config" "${USERPROFILE}/.config"

linkylink "${HOME}/.config/WindowsTerminal "$wtDest"
# yes, I've had one machine with all four PowerShell paths
linkylink "${HOME}/.config/PowerShell" "${HOME}/Documents/PowerShell"
linkylink "${HOME}/.config/PowerShell" "${HOME}/My Documents/PowerShell"
linkylink "${HOME}/.config/PowerShell" "${HOME}/Documents/WindowsPowerShell"
linkylink "${HOME}/.config/PowerShell" "${HOME}/My Documents/WindowsPowerShell"

# custom spelling dictionary
linkylink "${HOME}/.vim/spell/external/spellfile_custom.txt" "${APPDATA}/Microsoft/UProof/CUSTOM.DIC" 1
linkylink "${HOME}/.vim/spell/external/spellfile_custom.txt" "${APPDATA}/Microsoft/Teams/Custom Dictionary.txt" 1
linkylink "${HOME}/.vim/spell/external/spellfile_custom.txt" "${APPDATALOCAL}/Google/Chrome/User Data/Default/Custom Dictionary.txt" 1
linkylink "${HOME}/.vim/spell/external/spellfile_custom.txt" "${firefoxDictPath}" 1

