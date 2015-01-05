# TMUX detection
function launch_tmux {
    # check if tmux is installed
    if type tmux 2>&1 >/dev/null; then

        # if NOT inside a session AND no server yet exits, start a new server and new session
        if  (test -z ${TMUX} && [[ -z $(pidof tmux) ]]); then

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
        elif (test -z ${TMUX}) && $(tmux has-session -t main); then

            echo 'trying to connect to main session'
            if (test -z $(tmux list-clients -t main)); then
                tmux attach && exit
            else
                tmux new-session zsh && exit
            fi
        elif (test -n ${TMUX}); then
            echo 'new tmux pseudo-shell'
        fi
        [[ -z $TMUX ]] && echo 'This is outside a tmux shell! Think of all the potential you waste...'
    fi
}
