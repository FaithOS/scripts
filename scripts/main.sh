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
echo "当前系统 $OS_NAME_VERSION"
#MY_PROFILE
CHECK_USER
SELECT_LIST
CLEAN

}
main
