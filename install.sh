#!/bin/bash

# check for an existing vim installation
if ! (command -v vim >/dev/null 2>&1); then
	echo "Error: You have to install vim first" >&2
	exit 1
fi

# check for an existing git installation
if ! (command -v git >/dev/null 2>&1); then
	echo "Error: You have to install git first" >&2
	exit 1
fi

# install vim-plug
# this line was copied from the vimplug README file
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# create ~/.vimrc with the content of the vimrc file in this directory
if [[ ~/.vimrc  ]]; then
	echo "~/.vimrc found, appending configuration to this file"
	echo $(dirname)/vimrc >> ~/.vimrc
else
	echo "Installing ~/.vimrc"
	cp $(dirname)/vimrc ~/.vimrc
fi


# start vim, install the plugins and quit it again
vim +PlugInstall +qall
