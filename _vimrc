" pas de compatibilité avec le vi original
set nocompatible

" requis par Vundle
filetype off

" initialize Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" thème de couleurs solarized
Plugin 'altercation/vim-colors-solarized'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" apparence
set background=dark
colorscheme solarized

