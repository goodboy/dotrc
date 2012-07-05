#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


export PS1='\[\033[01;31m\]\u@\h \[\033[01;34m\]\W \n\$ \[\033[00m\]'
#PS1='[\u@\h \W]\$ '
set -o vi
bind -m vi-insert "\M-.:yank-last-arg"
bind -m vi-insert "\M-_:yank-mth-arg"
#
# Aliases
#
alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable --group-directories-first'
alias grep='grep --color=auto'
alias cower='cower --color=auto'
alias tmux='tmux -2'

export HISTSIZE=10000
export EDITOR=vim

# Git tab completion
if [ -f $HOME/.git-completion.bash ]
then
    export PS1='\[\033[01;31m\]\u@\h \[\033[01;34m\]\W$(__git_ps1 " (%s)") \n\$ \[\033[00m\]'
    . $HOME/.git-completion.bash
fi

# Coloured man page support using 'less' (code taken from arch wiki)
function man {
    
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

function Make() {
	nice make $* 2>&1 | tee make.out
}
