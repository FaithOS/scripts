#!/bin/bash
# 

for i in ./main_profile/*.sh  ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done


main (){
CHECK_USER
SELECT_LIST
CLEAN

}
main
