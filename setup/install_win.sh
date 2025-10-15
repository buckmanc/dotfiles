#!/usr/bin/env bash

# winget install git.git # how are you here if you don't have win git?
winget install starship.starship
winget install gnuwin32.tree
winget install vim.vim # vim for cmd, powerShell
winget install notepad++.notepad++
winget install 7zip.7zip
winget install windirstat
winget install microsoft.powershell
winget install microsoft.dotnet.sdk.6
winget install microsoft.dotnet.sdk.7
winget install --id microsoft.windowsterminal -e
winget install jqlang.jq
winget install videolan.vlc
winget install streamlink.streamlink
winget install imagemagick

cp "${PROGRAMFILES} (x86)/GnuWin32/bin/tree.exe" "${PROGRAMFILES}/Git/usr/bin/"

~/bin/vimplugupdate

# winget install python # check version at run time

# winget install mozilla.firefox
# winget install microsoft.visualstudio.2022.Professional
# winget install microsoft.visualstudio.2022.Community

# TODO install missing bash apps
# www2.futureware.at/~nickoe/msys2-mirror/msys/x86_64
# to ~/.local/bin
# bc
# dc
# rsync
# msys-xxhash-o.dll

# TODO schtasks nerdmoon install; schtasks -create -sc hourly -tn nerdmoon -tr ~/bin/nerdmoon
