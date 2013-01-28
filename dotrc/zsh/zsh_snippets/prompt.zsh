# prompt settings

# options
setopt prompt_subst
autoload -U vcs_info
autoload -U colors && colors

# vcs style settings
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

# vimode=I
# # set vimode to current editing mode
# function zle-line-init zle-keymap-select {
#     vimode="${${KEYMAP/vicmd/C}/(main|viins)/}"
#     zle reset-prompt
# }

function vcs_info_wrapper {
    vcs_info
   [[ -n "$vcs_info_msg_0_" ]] && echo " %{$fg[grey]%}${vcs_info_msg_0_/ /}%{$reset_color%}"
}

# RPROMPT pwd updating
function precmd {
        # only update right-prompt on dir change
        if [[ ${cur_dir} != ${PWD} ]]; then
            set_rprompt
            unset set_rprompt
            cur_dir=${PWD}
        else
            unset RPROMPT
            # RPROMPT=""
        fi
        echo    # add a new line to each output
}

# RPROMPT="%{$reset_color%}[%{$fg[green]%}%~%{$reset_color%}]"
function set_rprompt {
    local pmt="red"
    (( EUID == 0 )) && pmt="blue"
    [[ -n $SSH_CONNECTION ]] && pmt="magenta"
    # PROMPT="┌┤%{$fg[green]%}%n%{$reset_color%}>%{$fg[${pmt}]%}%m%{$reset_color%} %{$fg[blue]%}[%0~]%{$reset_color%}
    # └→ "

    RPROMPT=" %{$reset_color%}[%{$fg[green]%}%~%{$reset_color%}]"
    RPROMPT+='$(vcs_info_wrapper)'
    # RPROMPT+='%{$fg[yellow]%}%(?.. %?)%{$reset_color%}'
    # RPROMPT+='%{$fg[red]%} ${vimode} %{$reset_color%}'
}
set_rprompt
unset set_rprompt

# left prompt
pmt="green"
PROMPT="%{$fg[${pmt}]%}->%#%{$reset_color%}"

# use cursor as indicator of vi mode
cmd_mode_col="red"
cursor_col="grey"

zle-keymap-select () {
    if [ $KEYMAP = vicmd ]; then
        if [[ $TMUX = '' ]]; then
           echo -ne "\033]12;${cmd_mode_col}\007"

        elif [[ $TERM = 'screen-256color' ]]; then
           printf "\033Ptmux;\033\033]12;${cmd_mode_col}\007\033\\"
        fi
    else
        if [[ $TMUX = '' ]]; then
           echo -ne "\033]12;${cursor_col}\007"

        elif [[ $TERM = 'screen-256color' ]]; then
           printf "\033Ptmux;\033\033]12;${cursor_col}\007\033\\"
        fi
    fi
}
# zle -N zle-keymap-select

# zle-line-init () {
#    zle -K viins
#    if [[ $TERM = 'screen-256color' ]]; then
#        echo -ne "\033]12;${cursor_col}\007"
#    fi
# }
# zle -N zle-line-init

# insert sudo to bol on ALT-s
insert_sudo () {
    zle beginning-of-line
    zle -U "sudo "
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Show "waiting dots" while something tab-completes
# (found on zsh-users)
expand-or-complete-with-dots() {
    echo -n "\e[31m...\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots
