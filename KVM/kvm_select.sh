#!/bin/sh
#

NAME_DOMAIN=(`/usr/bin/virsh list | awk '{print $2}'`)
for ((a=0;a<="${#NAME_DOMAIN[@]}";a++));do
NAME_DOMAIN=(`/usr/bin/virsh list | awk '{print $2}'`)
DOMAIN_PID=`ps aux | grep "${NAME_DOMAIN[$a]}"  |awk  '{print $2}' |sed -n 1p`
DOMAIN_PORT=`netstat -lntp | grep "$DOMAIN_PID" |awk '{print $4}'`
echo "${NAME_DOMAIN[$a]}  $DOMAIN_PORT"
if [ $a -eq ${#NAME_DOMAIN[@]}  ];then
echo '结束'
fi
done
