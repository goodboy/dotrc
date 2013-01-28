# set my environment

export GREP_OPTIONS='--color=auto'
export GREP_COLOR=$'4;1;31'
export SUDO_PROMPT=$'\e[31mSUDO\e[m password for \e[34m%p\e[m: '

[[ -f ~/etc/dircolors/dircolors ]] && \
      eval $(dircolors ~/etc/dircolors/dircolors)

# Coloured man page support
# using 'less' env vars, format : '\E[<brightness>;<colour>m'
export LESS_TERMCAP_mb=$'\E[01;31m'     # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'         # end mode
export LESS_TERMCAP_so=$'\E[01;44;36m'  # begin standout-mode (bottom of screen)
export LESS_TERMCAP_se=$'\E[0m'         # end standout-mode
export LESS_TERMCAP_us=$'\E[00;36m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'         # end underline
