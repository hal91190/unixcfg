#!/usr/bin/env bash

# Debug
# set -xv

CFG_DIR="$HOME/configs"
OS="$(uname -s | { read -r -a array ; echo "${array[0]}" ; })"

# Create a symbolic link for a config file
# #1 source for the link
# #2 link name
function create_link {
    SRC="$CFG_DIR/$1"
    DEST="$2"
    if [[ -h $DEST || ! -e $DEST ]]; then
        [[ -h $DEST ]] && {
        echo "Removing old symbolic link $DEST"
        unlink "$DEST"
    }
    echo "Creating symbolic link $DEST -> $SRC"
    ln -s "$SRC" "$DEST"
else
    echo "$DEST already exists and is not a symbolic link => Aborting link creation"
fi
}

# Create a symbolic link in the user home dir for a config file or directory
# #1 element to install
#    if the name begins with a "_", it will be replaced by a "."
function install_cfg {
    if [[ $1 = _* ]]; then
        DEST="$HOME/${1/_/.}"
    else
        DEST="$HOME/$1"
    fi
    create_link "$1" "$DEST"
}

if [[ $OS = "Linux" || $OS = "Darwin" ]]; then
    echo "Installing (or updating) configuration for $OS platform"
else
    echo "This script does not support this platform ($OS)"
fi

if [[ $OS = "Darwin" ]]; then
    echo "Applying specific configuration to $OS"
    echo "Configuring terminal on Mac OS X"
    install_cfg _minttyrc
fi

# Bash
install_cfg _bash_aliases
install_cfg _bash_functions
install_cfg _bashrc

# Tmux
install_cfg _tmux.conf

# Git
install_cfg _gitconfig
if [[ ! -d "$HOME/Documents/Dev/git-subrepo/" ]]; then
    echo "Cloning git-subrepo"
    git clone https://github.com/ingydotnet/git-subrepo.git "$HOME/Documents/Dev/git-subrepo/"
else
    echo "Pulling git-subrepo"
    git -C "$HOME/Documents/Dev/git-subrepo/" pull
fi

# Default applications for Gnome
create_link defaults.list "$HOME/.local/share/applications/defaults.list"

# ViM
install_cfg _vimrc
install_cfg _vim
if [[ ! -d "$CFG_DIR/_vim/bundle/Vundle.vim" ]]; then
    echo "Cloning Vundle"
    git clone https://github.com/gmarik/Vundle.vim.git "$CFG_DIR/_vim/bundle/Vundle.vim"
else
    echo "Pulling Vundle"
    git -C "$CFG_DIR/_vim/bundle/Vundle.vim" pull
fi
vim +PluginInstall +qall

# notes.sh
echo "Installing note taking script"
NOTES_SH_URL="https://gist.github.com/hal91190/20d361c317b71232d8edb7496f2bbe14/raw"
if [[ ! -d "$HOME/bin" ]]; then
    mkdir -p "$HOME/bin"
fi
echo "Retrieving and installing notes.sh in $HOME/bin"
wget -q -P "$HOME/bin" "$NOTES_SH_URL/notes.sh"
chmod +x "$HOME/bin/notes.sh"
echo "Retrieving and installing .notesrc in $HOME"
wget -q -P "$HOME" "$NOTES_SH_URL/.notesrc"
echo "Retrieving and installing notes-completion in /etc/bash_completion.d (with sudo)"
sudo wget -q -P "/etc/bash_completion.d" "$NOTES_SH_URL/notes-completion"

echo "Finish installation by running :"
echo "source \"$HOME/.bashrc\""

