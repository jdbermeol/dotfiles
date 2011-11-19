#!/bin/bash
DIR=$(dirname $(readlink -f $0))

if [ -f "$HOME/.vimrc" ]; then
	echo "Backing up vimrc"
	cp $HOME/.vimrc $HOME/.vimrc.bak
fi
echo "source $DIR/.vimrc" > $HOME/.vimrc
