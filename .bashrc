if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi

if [[ "$HOME" == *"termux"* ]]; then
	XENVIRO=mobile
elif [[ "$HOME" == *"OneDrive"* ]]; then
	XENVIRO=work
else
	XENVIRO=other
fi

export XENVIRO

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

mkdir -p "$HOME/.logs/screen"

# run the below command if you need/want to theme bash directly
# useful where terminal theming is hard
# echo ". ~/.bash_themes" >> ~/.bash_aliases_local && exec bash

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=1000
# HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
shopt -s nocaseglob # case insensitive globbing

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# less options
# case insensitive, interpret color codes, exit if all fits on one screen
# removing "all on one screen" as it doesn't calculate the height of the prompt, thus hiding the top row sometimes
export LESS="iR"

# standardize termux and non termux temp dir vars
if [[ -z "$TMPDIR" && -z "$TEMP" && -d "/tmp" ]]
then
	export TEMP="/tmp"
	export TMPDIR="/tmp"
elif [[ -z "$TMPDIR" && -n "$TEMP" && -d "$TEMP" ]]
then
	export TMPDIR="$TEMP"
elif [[ -z "$TEMP" && -n "$TMPDIR" && -d "$TMPDIR" ]]
then
	export TEMP="$TMPDIR"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

addtopath(){
	newPath="$1"
	newPath="$(echo "$newPath" | sed 's|^C:\\|/c/|g')"
	if [ -d "$newPath" ]
	then

		export PATH="$PATH:$newPath"
	fi
}
addtopathstart(){
	newPath="$1"
	newPath="$(echo "$newPath" | sed 's|^C:\\|/c/|g')"
	if [ -d "$newPath" ]
	then

		export PATH="$newPath:$PATH"
	fi
}

pyPath="$LOCALAPPDATA/Programs/Python/Python312"
streamlinkPath="$LOCALAPPDATA/Programs/Streamlink/bin"
jqPath="$LOCALAPPDATA\Microsoft\WinGet\Packages\jqlang.jq_Microsoft.Winget.Source_8wekyb3d8bbwe"

NVM_DIR="${HOME}/.nvm"
ANDROID_HOME="/media/content/Coding/androidsdk"

addtopathstart "${HOME}/bin"
addtopathstart "${HOME}/bin_local"
if [ "$XENVIRO" == "mobile" ]
then
	addtopath "${HOME}/bin_termux"
	addtopath "${HOME}/.shortcuts"
	addtopath "${HOME}/.shortcuts/tasks"
fi
addtopathstart "${LOCALAPPDATA}/Microsoft/WinGet/Links"
addtopathstart "$PROGRAMFILES/Vim/vim91"
addtopath "${HOME}/go/bin"
addtopath "${pyPath}"
addtopath "${pyPath}/scripts"
addtopath "$HOME/.local/bin"
addtopath "${streamlinkPath}"
addtopath "${jqPath}"
addtopath "${ANDROID_HOME}/cmdline-tools/latest/bin"
addtopath "${ANDROID_HOME}/platform-tools"
addtopath "${LOCALAPPDATA}/Pandoc"
addtopath "/c/Program Files (x86)/MakeMKV"
addtopath "$PROGRAMFILES/AutoHotkey/"
addtopath "$PROGRAMFILES/VideoLAN/VLC/"
addtopath "/c/Program Files (x86)/Google/Cloud SDK/google-cloud-sdk/bin"

if [ -d "${ANDROID_HOME}" ]
then
	export ANDROID_HOME
fi

if [ -d "${NVM_DIR}" ]
then
	export NVM_DIR
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# provide a standard user environment variable between platforms
if [[ -z "$USER" && -n "$USERNAME" ]]; then
	export USER="$USERNAME"
fi

complete -F _command which-vim

# prefer vim over nano
# crontab reads this variable
export EDITOR=vim
export COLUMNS

# no welcome message for dotnet
export DOTNET_NOLOGO=true
export DOTNET_ROOT=/usr/share/dotnet

function set_win_title(){
	
	text=$(basename "$PWD")

	# special character for home dir
	if [ "${HOME,,}" == "${PWD,,}" ]
	then
		# # very hacky bug fix for juicessh
		# if [ -z "$SSH_CLIENT" ] || [[ ("$COLUMNS" != "75" && "$COLUMNS" != 37) ]]
		# then
		# 	text="ᐰ"
		# fi

		text="ᐰ"
	fi

	# neat idea for pulling directly from starship to support substitutions
	# changing system fonts to a nerd font to get glyph support in the title bar is too painful though
	#
	# text="$(starship module directory)"
	# text=$(basename "$text")

	# # strip off color codes as they interfere with window titling
	# if type ansi2txt >/dev/null 2>&1
	# then
	# text="$(echo $"text" | ansi2txt)"
	# else
	# 	text="$(echo "$text" | sed -e "s/\x1b\[.\{1,5\}m//g")"
	# fi

	# only display hostname on certain platforms
	if [[ "$USER" != *"."* ]]
	then
		if [[ -z "$hostyHost" ]]
		then
			# if the hostname is useless, use the ostype instead
			if [[ "$HOSTNAME" == "localhost" ]]
			then
				# shorten android name
				if [[ "$OSTYPE" == "linux-android" ]]
				then
					hostyHost="android"

					# add the user number as a substitute for a useful hostname
					userNum="$(echo "$USER" | grep -iPo '(?<=^u0_a).+')"
					if [[ -n "$userNum" ]]
					then
						hostyHost="$hostyHost $userNum"
					fi
				else
					hostyHost="$OSTYPE"
				fi
			else
				hostyHost="$HOSTNAME"
			fi

			# try to cache the hostyHost
			export hostyHost
		fi

		text="$hostyHost - $text"
	fi

	echo -ne "\033]0;${text}\007"
}
starship_precmd_user_func="set_win_title"
# suppress warnings
export STARSHIP_LOG=error

if type starship >/dev/null 2>&1; then
	eval "$(starship init bash)"
fi

if [ -d /home/linuxbrew ]
then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# bash parameter completion for the dotnet CLI
# learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
if ( type dotnet > /dev/null 2>&1 )
then

	function _dotnet_bash_complete()
	{
	  local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
	  local candidates

	  read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)

	  read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
	}

	complete -f -F _dotnet_bash_complete dotnet
fi

# if type thefuck	>/dev/null 2>&1; then
# 	eval "$(thefuck --alias)"
# else
# 	# alias thefuck='pip install thefuck --user'
# 	# install bug fix version for now
# 	alias thefuck='pip install https://github.com/DJStompZone/thefuck/archive/master.zip --break-system-packages --user'
# fi

# thefuck is dead, long live pay-respects
# github.com/nvbn/thefuck/issues/1466
if type pay-respects >/dev/null 2>&1; then
	eval "$(pay-respects bash --alias --nocnf)"
	alias fuck=f
fi

if type pandoc >/dev/null 2>&1; then
	eval "$(pandoc --bash-completion)"
fi


if [[ -f /usr/share/bash-completion/completions/screen ]]
then
	source /usr/share/bash-completion/completions/screen
fi
# https://superuser.com/a/947240
function _complete_xscreen() {
	local does_screen_exist=$(type -t _screen_sessions)
	local cur=$2 # Needed by _screen_sessions
	if [[ "function" = "${does_screen_exist}" ]]; then
		# _screen_sessions "Detached"
		_screen_sessions
	fi
}
export -f _complete_xscreen
complete -F _complete_xscreen -o default xscreen
complete -F _complete_xscreen -o default xscrn

if [[ "$OSTYPE" == "msys" ]]
then
	# bug fix for grep on Windows
	export LC_ALL="en_US.UTF-8"
fi
