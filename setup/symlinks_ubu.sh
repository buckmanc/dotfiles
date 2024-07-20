#!/usr/bin/env bash

if [[ $EUID = 0 ]]
then
	echo 'cannot run this script as sudo as it will scre up user paths'
	return 1
fi

localHome="$HOME"

# same vim environment for root
sudo ln -sf "$localHome/.vimrc" /root/.vimrc
# symlinks don't work here
# sudo ln -sf "$localHome/.config/sudoerscustom" "/etc/sudoers.d/sudoerscustom"
sp "$localHome/.config/sudoerscustom" "/etc/sudoers.d/sudoerscustom"
sudo chown 0 "/etc/sudoers.d/sudoerscustom"
sudo chgrp 0 "/etc/sudoers.d/sudoerscustom"
