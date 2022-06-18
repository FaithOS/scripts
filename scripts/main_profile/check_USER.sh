#/bin/bash
CHECK_USER(){
#检查当前用户是否为root
if [ `id -u` -ne 0 ];then
    echo "This scripts must run with root !!!"
fi
}
action(){
        MSG=$1
        COLOER=`echo $1|sed 's#^.*\[\(.*\)\].*#\1#g'`
        BASE=`echo $1|sed 's#\(^.*\)\[.*]#\1#g'`
        if [ "OK" != "$COLOER" ];then
                echo -e "${BASE} [\e[0;31;1m  $COLOER  \e[0m]"
        else
                echo -e "${BASE} [\e[1;32m $COLOER \e[0m]"
        fi
}
