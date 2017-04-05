" Références
" http://items.sjbach.com/319/configuring-vim-right
" http://nvie.com/posts/how-i-boosted-my-vim/
" http://usevim.com/tags.html
" https://gist.github.com/joegoggins/8482408

" {{{ Vundle
" pas de compatibilité particulière avec le vi original
set nocompatible             " requis par Vundle

" définit le caractète leader
let mapleader = ","

" désactive la détection du type de fichier au chargement
filetype off                 " requis par Vundle

" initialisation de Vundle
set rtp+=~/.vim/bundle/Vundle.vim " requis par Vundle
call vundle#begin()          " requis par Vundle

" Vundle gère Vundle
Plugin 'gmarik/Vundle.vim'   " requis par Vundle

" après l'ajout d'un plugin
" :BundleInstall dans vim, ou
" vim +BundleInstall +qall en ligne de commande

" thème de couleurs solarized
Plugin 'altercation/vim-colors-solarized'

" ligne de status améliorée
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" explorateur de fichiers
Plugin 'scrooloose/nerdtree.git'

" Snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Magellan color scheme
Plugin 'tokers/Magellan'

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

" espaces et tabulations
" use shiftwidth and tabstop smartly
set smarttab

" remplace les tabulations par des espaces
set expandtab

" correspondances tabulation/espace
set tabstop=4
set softtabstop=4
set shiftwidth=4

" pas d'insertion de saut de ligne
set textwidth=0
set wrapmargin=0

" retour à ligne visuel automatique
set wrap
set linebreak
let &showbreak='+++ ' 
set nolist

" mise en évidence de la largeur limite
set colorcolumn=100
" }}}

" {{{ comportement
" autorise un buffer modifié à passer en arrière plan
set hidden

" augmente la taille de l'historique
set history=1000

" améliore le matching avec %
runtime macros/matchit.vim

" améliore la complétion
set wildmenu
set wildmode=list:longest

" configure la recherche
set ignorecase
set smartcase

" fixe le titre du terminal
set title

" défile à 3 lignes du bord
set scrolloff=3

" backspace en mode insertion
set backspace=indent,eol,start

" mise en évidence des termes de recherche
set hlsearch
set incsearch

" tabulations et espace de fin visible à la demande
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" signal visuel plutôt que sonore
set visualbell

" recharge automatiquement un fichier modifié
set autoread
" }}}

" {{{ ligne de status et airline
" lighne de status en bas
set laststatus=2
" ligne d'informations en haut de l'écran (liste des buffers)
"let g:airline#extensions#tabline#enabled = 1
" }}}

" {{{ raccourcis
" désactive la mise en évidence de la recherche
nmap <silent> <Leader>n :nohls<CR>

" supprime les espaces en fin de ligne
nmap <silent> <Leader>rmtrail :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" ouvre/charge le .vimrc
nmap <silent> ,ev :e $MYVIMRC<CR>
nmap <silent> ,sv :so $MYVIMRC<CR>

" }}}

" {{{ NERD Tree
" ouverture/fermeture
nmap <F7> :NERDTreeToggle<CR>
nmap <S-F7> :NERDTreeClose<CR>

" }}}

" {{{ UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

" {{{ apparence
if has('gui_running')
  set lines=60 columns=102 linespace=0
  "set guioptions-=m          " menu
  "set guioptions-=T          " toolbar
  "set guioptions-=r          "ascenseur de droite
  "set guioptions-=L          "ascenseur de gauche
  if LINUX()
    set guifont=Source\ Code\ Pro\ Medium\ 12,Droid\ Sans\ Mono\ 12,Courier\ New\ Regular\ 13
  elseif OSX()
    set guifont=Droid\ Sans\ Mono:h12,Courier\ New\ Regular:h13
  elseif WINDOWS()
    set guifont=Courier_New:h10
  endif
  set antialias
  set background=dark
  colorscheme solarized
else
  colorscheme magellan
endif

" montre les correspondances de parenthèses
set showmatch

" active la coloration syntaxique
syntax on
" }}}

