#!/bin/bash
#

for i in ./main_check/*.sh  ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done


main (){

CHECK_OS
CHECK_USER
SELECT_LIST
}
main
