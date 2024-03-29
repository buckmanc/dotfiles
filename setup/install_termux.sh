#!/usr/bin/env bash

pkg upgrade

# does this need to be permanent?
export LDFLAGS="-landroid-spawn -lm -lpython3.11" 

pip install git+https://github.com/numpy/numpy
pip install git+https://github.com/TotallyNotChase/glitch-this

pkg install ruby
gem install lolcat

termux-setup-storage


# installed apps as of 2023-11-22
# bash-completion
# bash
# binutils-bin
# binutils-libs
# binutils
# brotli
# bzip2
# ca-certificates
# clang
# cmake
# command-not-found
# coreutils
# cowsay
# cronie
# curl
# dash
# debianutils
# dialog
# diffutils
# dnsutils
# dos2unix
# dpkg
# ed
# fftw
# file
# findutils
# fontconfig
# freetype
# fribidi
# gawk
# gdbm
# gdk-pixbuf
# giflib
# git
# glib
# gpgv
# grep
# gzip
# harfbuzz
# imagemagick
# imath
# inetutils
# jq
# jsoncpp
# krb5
# ldns
# less
# libandroid-execinfo
# libandroid-glob
# libandroid-posix-semaphore
# libandroid-shmem
# libandroid-spawn
# libandroid-support
# libaom
# libarchive
# libassuan
# libbz2
# libc++
# libcairo
# libcap-ng
# libcompiler-rt
# libcrypt
# libcurl
# libdav1d
# libdb
# libde265
# libedit
# libevent
# libexpat
# libffi
# libgcrypt
# libgmp
# libgnutls
# libgpg-error
# libgraphite
# libheif
# libiconv
# libidn2
# libjpeg-turbo
# libjxl
# libllvm
# liblz4
# liblzma
# liblzo
# libmd
# libmpfr
# libnettle
# libnghttp2
# libnpth
# libpixman
# libpng
# libpopt
# librav1e
# libresolv-wrapper
# librsvg
# libsmartcols
# libsqlite
# libssh2
# libtiff
# libtirpc
# libunbound
# libunistring
# libuuid
# libuv
# libwebp
# libx11
# libx265
# libxau
# libxcb
# libxdmcp
# libxext
# libxft
# libxml2
# libxrender
# littlecms
# lld
# llvm
# lsof
# make
# man
# moreutils
# nano
# ncurses-ui-libs
# ncurses
# ndk-sysroot
# neofetch
# net-tools
# ninja
# oniguruma
# openexr
# openjpeg
# openssh-sftp-server
# openssh
# openssl-tool
# openssl
# pango
# patch
# patchelf
# pcre2
# pcre
# perl
# pkg-config
# procps
# psmisc
# python-ensurepip-wheels
# python-pip
# python
# readline
# resolv-conf
# rhash
# rsync
# runit
# screen
# sed
# starship
# tar
# tealdeer
# termux-am-socket
# termux-am
# termux-api
# termux-auth
# termux-exec
# termux-keyring
# termux-licenses
# termux-services
# termux-tools
# tree
# ttf-dejavu
# unbound
# unzip
# util-linux
# vim-python
# vim-runtime
# wget
# which
# xxhash
# xz-utils
# zlib
# zstd
