# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# ssh-pageant
eval $(/usr/local/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")

# git-prompt
source /usr/local/bin/git-prompt.sh

# Show if there are unstaged (*) and/or staged (+) changes
export GIT_PS1_SHOWDIRTYSTATE=1

# Show if there is anything stashed ($)
export GIT_PS1_SHOWSTASHSTATE=1

# Show if there are untracked files (%)
export GIT_PS1_SHOWUNTRACKEDFILES=1

# Show how we're tracking relative to upstream
export GIT_PS1_SHOWUPSTREAM="verbose,name"

# Git prompt in color
export GIT_PS1_SHOWCOLORHINTS=1

# Prompt
C_NONE="\[\e[0m\]"
C_RED="\[\e[0;31m\]"
C_GREEN="\[\e[0;32m\]"
C_YELLOW="\[\e[0;33m\]"
C_BLUE="\[\e[0;34m\]"
C_PURPLE="\[\e[0;35m\]"
C_CYAN="\[\e[0;36m\]"
C_LGRAY="\[\e[0;37m\]"
C_LRED="\[\e[1;31m\]"
C_LGREEN="\[\e[1;32m\]"
C_LYELLOW="\[\e[1;33m\]"
C_LBLUE="\[\e[1;34m\]"
C_LPURPLE="\[\e[1;35m\]"
C_LCYAN="\[\e[1;36m\]"
C_WHITE="\[\e[1;37m\]"

PROMPT_COMMAND='__git_ps1 "${C_PURPLE}\u${C_BLUE}@${C_PURPLE}\h${C_BLUE}:${C_GREEN}\w${C_NONE}" "${C_BLUE}\\$ ${C_NONE}"'
export PROMPT_COMMAND
