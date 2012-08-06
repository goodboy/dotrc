#!/bin/bash
# script to test exit codes with command substitution

for f in ( ./* dogs.txt ); do

    declare err=$(cat ${f}) || exit $? && echo command substitution failed
    #echo last err is = $?

    if [[ $? == 0 ]]; then
        echo inside if!
        echo ${f}
        echo "${err}"
    fi
    echo made it to the end!
done
