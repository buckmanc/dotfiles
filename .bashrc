if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

if [ -d ~/go/bin ]; then
	export PATH=$PATH:~/go/bin
fi

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# provide a standard user environment variable between platforms
if [ -z "$USER" ]; then
	export USER="$USERNAME"
fi

function set_win_title(){
	
	text=$(basename "$PWD")

	# special character for home dir
	if [ "${HOME,,}" == "${PWD,,}" ]
	then
		# very hacky bug fix for juicessh
		if [ -z "$SSH_CLIENT" ] || [[ ("$COLUMNS" != "75" && "$COLUMNS" != 37) ]]
		then
			text="ᐰ"
		fi
	fi

	# only display hostname on certain platforms
	if [[ "$USER" != *"."* ]]
	then
		text="${HOMENAME} - ${text}"
	fi

	echo -ne "\033]0;${text}\007"
}
starship_precmd_user_func="set_win_title"

if type starship >/dev/null 2>&1; then
	eval "$(starship init bash)"
fi
