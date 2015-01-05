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

# zstyle ':vcs_info:*' stagedstr "${fg_blue}?"
# zstyle ':vcs_info:*' unstagedstr "${fg_brown}?"
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
# zstyle ':vcs_info:*' enable git svn

# vimode=I
# # set vimode to current editing mode
# function zle-line-init zle-keymap-select {
#     vimode="${${KEYMAP/vicmd/C}/(main|viins)/}"
#     zle reset-prompt
# }

function vcs_info_wrapper {
   vcs_info
   [[ -n "$vcs_info_msg_0_" ]] && echo " %{$fg[gray]%}${vcs_info_msg_0_/ /}%{$reset_color%}"
}

function precmd {
    # if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
    #     zstyle ':vcs_info:*' formats "${at_normal} ${fg_dgray}%b%c%u${at_normal}"
    # } else {
    #     zstyle ':vcs_info:*' formats "${at_normal} ${fg_dgray}%b%c%u${fg_red}!${at_normal}"
    # }
    # vcs_info

    echo  # add a new line to each output
    # update the xterm title with `username@hostname pwd`
    case $TERM in
        xterm*)
            print -Pn "\e]0;%n@%m: %~\a";;
    esac
}

# enable later substitution in prompt
# setopt PROMPT_SUBST

# RPROMPT="%{$reset_color%}[%{$fg[green]%}%~%{$reset_color%}]"
function set_rprompt {
    local pmt="red"
    (( EUID == 0 )) && pmt="blue"
    [[ -n $SSH_CONNECTION ]] && pmt="magenta"
    # RPROMPT="%{$reset_color%}%(?/${at_normal}/${fg_red})%%${at_normal}"
    RPROMPT='$(vcs_info_wrapper)'
    # RPROMPT+="%c \${vcs_info_msg_0_}"
    # RPROMPT+='%{$fg[yellow]%}%(?.. %?)%{$reset_color%}'
    # RPROMPT+='%{$fg[red]%} ${vimode} %{$reset_color%}'
}
set_rprompt
unset set_rprompt

# left prompt
pmt="green"
PROMPT="%{$fg[${pmt}]%} >>> %{$reset_color%}"

# use cursor as indicator of vi mode
# urxvt (and family) accepts even #RRGGBB
INSERT_PROMPT="gray"
COMMAND_PROMPT="red"

# helper for setting color including all kinds of terminals
set_prompt_color() {
    if [[ $TERM = "linux" ]]; then
        # nothing
    elif [[ $TMUX != '' ]]; then
        printf '\033Ptmux;\033\033]12;%b\007\033\\' "$1"
    else
        echo -ne "\033]12;$1\007"
    fi
}

# change cursor color based on vi mode
zle-keymap-select () {
    if [ $KEYMAP = vicmd ]; then
        set_prompt_color $COMMAND_PROMPT
    else
        set_prompt_color $INSERT_PROMPT
    fi
}

zle-line-finish() {
    set_prompt_color $INSERT_PROMPT
}

zle-line-init () {
    zle -K viins
    set_prompt_color $INSERT_PROMPT
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# Show "waiting dots" while something tab-completes
# (found on zsh-users)
expand-or-complete-with-dots() {
    echo -n "\e[31m...\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots

# map tab key to call the above routine
bindkey "^I" expand-or-complete-with-dots
