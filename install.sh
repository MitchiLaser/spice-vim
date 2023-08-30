#!/bin/bash

# install vim-plug
# this line was copied from the vimplug README file
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# create ~/.vimrc with the content of the vimrc file in this directory
if [[ ~/.vimrc  ]]
	echo "~/.vimrc found, appending configuration to this file"
	echo $(dirname)/vimrc >> ~/.vimrc
else
	echo "Installing ~/.vimrc"
	cp $(dirname)/vimrc ~/.vimrc
fi

# start vim, install the plugins and quit it again
vim +PlugInstall +qall
