#
# Tyler Goodlet .zshrc config file
#

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

setopt appendhistory 
#setopt autocd 
setopt autopushd
setopt extendedglob 
setopt nomatch 
setopt notify

unsetopt beep
bindkey -v

#none of these effing work!?!
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\eOc" emacs-forward-word
bindkey "\eOd" emacs-backward-word
bindkey "^H" backward-delete-word
bindkey '^R' history-incremental-search-backward

# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

# buffer stack access
bindkey '^w' push-line
bindkey '^e' get-line

# The following lines were added by compinstall
zstyle :compinstall filename '/home/tyler/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

#
# Aliases 
#
alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable --group-directories-first'
alias grep='grep --color=auto'
alias less='less -R'
alias cower='cower --color=auto'
alias tmux='tmux -2'
alias share='curl -F "sprunge=<-" http://sprunge.us | xclip'
alias ll='ls -l --classify --color=always --human-readable --group-directories-first | less'
#alias matlab ='/usr/local/bin/matlab -nodesktop -nosplash'

#
# Zsh FUNCTIONS 
#
#function precmd {
#        local cur_dir=''
#        if [[ $CUR_DIR != $PWD ]]; then
#            cur_dir=${PWD/#$HOME/~}
#            CUR_DIR=$cur_dir
#        else
#            cur_dir=""
#        fi
#        RPROMPT="%{$reset_color%}%{$fg[green]%}$cur_dir%{$reset_color%}"
#}


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

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PROMPT SETTINGS
# enables coloured prompt settings
autoload -U colors && colors
PROMPT="%{$fg[green]%}->%#%{$reset_color%}"
RPROMPT="%{$reset_color%}[%{$fg[green]%}%~%{$reset_color%}]"

# Enable tmux at shell start
#
# check if tmux is installed
if which tmux 2>&1 >/dev/null; then
    
    #if not running interactively, do not do anything
    [[ $- != *i* ]] && break

    # if NOT inside a session AND no server yet exits,
    # start a new server and new session
    if  ( test -z ${TMUX} && [[ -z $(pidof tmux) ]]); then

        echo 'starting new tmux server'
            
        # NOTE you must create a session (eg. new -s main zsh)
        # in ~/.tmux.conf or this attach line will fail if no prior 
        # session/server exists 
        tmux attach && exit
        
        echo ':exit shell as well? [Y/n]'
        read input
        if [[ $input == ( y || \n ) ]]; then
            exit 
        fi

    # if session exists then create a new window and attach to it
    # (this code is called whenever a new shell is opened outside tmux
    # and the tmux session 'main' already exists)
    elif (test -z $TMUX) && $(tmux has-session -t main); then

        echo 'trying to connect to main session'
        if (test -z $(tmux list-clients -t main)); then
            tmux attach && exit
        else
            tmux new-session zsh && exit
        fi
    elif (test -n ${TMUX}); then
        echo 'new tmux pseudo-shell'
    fi
    [[ $TERM != "screen-256color" ]] && echo 'This is outside a tmux shell! Think of all the potential you waste...'
fi

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# # From http://zshwiki.org/home/examples/zlewidgets
function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/ M:command}/(main|viins)/}"
    zle reset-prompt
}
zle -N zle-keymap-select

# change cursor to RED in vi normal mode
zle-keymap-select () {
    if [ $TERM = "screen-256color" ]; then
	if [ $KEYMAP = vicmd ]; then
	    echo -ne "\033]12;Red\007"
	else
	    echo -ne "\033]12;Grey\007"
	fi
    fi
}
zle -N zle-keymap-select
zle-line-init () {
    zle -K viins
    if [ $TERM = "rxvt-256color" ]; then
	echo -ne "\033]12;Grey\007"
    fi
}
zle -N zle-line-init
bindkey -v
