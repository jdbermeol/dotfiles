#!/bin/bash
DIR=$(dirname $(readlink -f $0))

if [ -f "$HOME/.vimrc" ]; then
    echo "Backing up vimrc"
    cp $HOME/.vimrc $HOME/.vimrc.bak
fi
if [ -f "$HOME/.bashrc" ]; then
    echo "Backing up bashrc"
    cp $HOME/.bashrc $HOME/.bash.bak
fi
echo "source $DIR/.vimrc" > $HOME/.vimrc
echo "source $DIR/.bashrc" > $HOME/.bashrc
