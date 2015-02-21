#!/usr/bin/env bash

# Debug
# set -xv

CFG_DIR=~/configs

# crée un lien symbolique pour un fichier de config
# #1 source du lien
# #2 lien à créer
function create_link {
	SRC=$CFG_DIR/$1
	DEST=$2
	if [ -h $DEST -o ! -e $DEST ]; then
		[ -h $DEST ] && unlink $DEST
		echo "Création du lien symbolique $DEST -> $SRC."
		ln -s $SRC $DEST
	else
		echo "$DEST n'est pas un lien symbolique."
	fi
}

# crée un lien symbolique pour un fichier de config
# #1 fichier à installer
#    si le nom du fichier débute par un _, il sera remplacé par un .
function install_cfg_file {
	if [ ${1:0:1} = "_" ]; then
		DEST=~/${1/_/.}
	else
		DEST=~/$1
	fi
    create_link $1 $DEST
}

# Le terminal sur Mac OS X
install_cfg_file _minttyrc

# Bash
install_cfg_file _bash_aliases
install_cfg_file _bash_functions
install_cfg_file _bashrc

# Git
install_cfg_file _gitconfig
create_link _vim ~/.vim

# ViM
install_cfg_file _vimrc

# Applications par défaut sous Gnome
create_link defaults.list ~/.local/share/applications/defaults.list

