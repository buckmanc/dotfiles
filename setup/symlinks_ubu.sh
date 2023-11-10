#!/usr/bin/env bash

if [ $EUID > 0 ]
then
	echo 'please sudo this script'
	return 1
fi

# same vim environment for root
ln -sf "${HOME}/.vimrc" /root/.vimrc
ln -sf "${HOME}/.config/sudoerscustom" "/etc/sudoers.d/sudoerscustom"
chown 0 "/etc/sudoers.d/sudoerscustom"
chgrp 0 "/etc/sudoers.d/sudoerscustom"
