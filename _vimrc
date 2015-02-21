" {{{ Vundle
" pas de compatibilité particulière avec le vi original
set nocompatible             " requis par Vundle

" désactive la détection du type de fichier au chargement
filetype off                 " requis par Vundle

" initialisation de Vundle
set rtp+=~/.vim/bundle/Vundle.vim " requis par Vundle
call vundle#begin()          " requis par Vundle

" Vundle gère Vundle
Plugin 'gmarik/Vundle.vim'   " requis par Vundle

" thème de couleurs solarized
Plugin 'altercation/vim-colors-solarized'

" tous les plugins Vundle doivent être ajoutés avant cette ligne
call vundle#end()            " requis par Vundle

" active la détection du type de fichier au chargement
" charge le fichier de plugin pour le type de fichier détecté (plugin)
" charge le fichier d'indentation pour le type de fichier détecté (indent)
filetype plugin indent on    " requis par Vundle
" }}}

" {{{ fonctions utilitaires
" sous Linux ?
silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" sous Mac OS X ?
silent function! OSX()
  return has('macunix')
endfunction

" sous Windows ?
silent function! WINDOWS()
  return (has('win16') || has('win32') || has('win64'))
endfunction
" }}}

" {{{ encodage des caractères
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif
" }}}

" {{{ Folding
" Fold with triple curly braces, fill with spaces
if has("folding")
  set foldenable
  set foldmethod=marker
  set foldopen=hor,search,tag,undo
  set fillchars=diff:\ ,fold:\ ,vert:\
endif
" }}}

" {{{ formatage
" indentation automatique des nouvelles lignes
set autoindent

" montre les correspondances de parenthèses
set showmatch

" espaces et tabulations
" use shiftwidth and tabstop smartly
set smarttab

" remplace les tabulations par des espaces
set expandtab

" correspondances tabulation/espace
set tabstop=4
set softtabstop=4
set shiftwidth=4

" largeur du texte
set textwidth=100

" pas de retour à ligne automatique
set nowrap

" mise en évidence de la 1ère colonne après la largeur limite
if exists("&colorcolumn")
  set colorcolumn=+1
endif
" }}}

" {{{ apparence
" thème de couleur
set background=dark
silent! colorscheme solarized

" GUI
if has('gui_running')
  set lines=60 columns=102 linespace=0
  "set guioptions-=m          " menu
  "set guioptions-=T          " toolbar
  "set guioptions-=r          "ascenseur de droite
  "set guioptions-=L          "ascenseur de gauche
  if LINUX()
    set guifont=Droid\ Sans\ Mono\ 12,Courier\ New\ Regular\ 13
  elseif OSX()
    set guifont=Droid\ Sans\ Mono:h12,Courier\ New\ Regular:h13
  elseif WINDOWS()
    set guifont=Courier_New:h10
  endif
endif

" active la coloration syntaxique
syntax on
" }}}

