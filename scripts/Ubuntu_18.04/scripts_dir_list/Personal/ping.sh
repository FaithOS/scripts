#!/bin/bash
# ping多台机器 ping.sh
function PING()
{
   (ping $1 -W 1 -q -c 3 >/dev/null 2>&1
   if [ $? -eq 0 ];then
       echo $1 >> /root/success-ip.list
   else 
       echo $1 >> /root/fail-ip.list 	   	
   fi
   )&
}




for i in `seq 1 254`
do
    PING 101.227.251.$i
done