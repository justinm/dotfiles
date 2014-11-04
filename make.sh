#!/bin/bash

installSymlink() {
	if [ -e "$2" ]; then
		mv "$2" "$2.orig"
		ln -s "$1" "$2"
	fi
}

uninstallSymlink() {
	[ -L "$1" ] && rm "$1"
	[ -e "$1.orig" ] && mv "$1.orig" "$1"
}


if [ "$1" = "install" ]; then
	installSymlink $PWD/.vimrc ~/.vimrc
	installSymlink $PWD/.vim ~/.vim
fi

if [ "$1" = "uninstall" ]; then
	uninstallSymlink ~/.vimrc
	uninstallSymlink ~/.vim
fi

