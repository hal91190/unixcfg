if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# ls
alias ls='ls -hF --color=auto'
alias l='ls -l'
alias ll='ls -lA'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# Mode d'affichage plus lisible
alias df='df -h'
alias du='du -h'

# Grep en couleur
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

