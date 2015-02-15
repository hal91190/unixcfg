#!/usr/bin/env bash

# Debug
# set -xv

CFG_DIR=~/configs

# crée un lien symbolique pour un fichier de config
# #1 fichier à installer
#    si le nom du fichier débute par un _, il sera remplacé par un .
function install_cfg_file {
	if [ ${1:0:1} = "_" ]; then
		DEST=~/${1/_/.}
	else
		DEST=~/$1
	fi
	if [ -h $DEST -o ! -e $DEST ]; then
		[ -e $DEST ] && unlink $DEST
		echo "Création du lien symbolique $DEST -> $CFG_DIR/$1."
		ln -s $CFG_DIR/$1 $DEST
	else
		echo "$DEST n'est pas un lien symbolique."
	fi
}

# Le terminal sur Mac OS X
install_cfg_file .minttyrc

# Bash
install_cfg_file .bash_aliases
install_cfg_file .bash_functions
install_cfg_file .bashrc

# Git
install_cfg_file _gitconfig

