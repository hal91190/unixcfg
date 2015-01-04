#!/usr/bin/env bash

# Debug
# set -xv

CFG_DIR=~/configs

function install_cfg_file {
	DEST=~/$1
	if [ -h $DEST -o ! -e $DEST ]; then
		[ -e $DEST ] && unlink $DEST
		ln -s $CFG_DIR/$1 $DEST
	else
		echo "$DEST is not a symlink."
	fi
}

install_cfg_file .minttyrc

install_cfg_file .bash_aliases
install_cfg_file .bash_functions
install_cfg_file .bashrc
