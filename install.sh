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
if [[ -f $HOME/.vimrc ]]; then
	echo "~/.vimrc found, appending configuration to this file"
	mv $HOME/.vimrc $HOME/.vimrc_old
	cp $(dirname "$0")/vimrc $HOME/.vimrc
	cat $HOME/.vimrc_old >> $HOME/.vimrc
	echo "Old ~/.vimrc can be found under ~/.vimrc_old"
else
	echo "Installing ~/.vimrc"
	cp $(dirname "$0")/vimrc $HOME/.vimrc
fi

# install spell files before first execution
mkdir -p $HOME/.vim/spell
wget "http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl" -q -O $HOME/.vim/spell/de.utf-8.spl
wget "http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.sug" -q -O $HOME/.vim/spell/de.utf-8.sug

# start vim, install the plugins and quit it again
vim +PlugInstall +qall

# deoplete requires pynvim to be installed
# and hdl-ckecker is a dependency for the vim hdl-checker plugin
pip3 install --user pynvim hdl-checker --upgrade
