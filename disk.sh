#!/bin/sh
DIS_LIST=`fdisk -l |awk -F " |:" '{if ($1~/Dis/) print $2 }' |egrep -v 'identifier' `
SYS_DIS=`fdisk -l | egrep "^\/" |awk '{if ($2~/\*/) print $1 }'`
SYS_NUM=`fdisk  -l | grep  "${SYS_DIS%[[:digit:]]}"| wc -l`
SYS_DIS_TWO=` df -h  | sed -n '2p' |awk '{print $1}'`
if   [ ${SYS_DIS}  == $SYS_DIS_TWO  ] ;then
    echo  "确认系统盘为 ： ${SYS_DIS%[[:digit:]]} 。"
fi
A=`echo  "${DIS_LIST}" |sed -n '2p' `
#b=`fdisk -l | grep ${A%[[:digit:]]}`
b=`fdisk -l | grep '/dev/xvdb' |sed -n '2p' |awk  '{print $1}'`
if [ -n "$A" -a  -z "$b"  ];then
    echo  " ${A} 是数据盘, 可以初始化。 "
fdisk $A <<EOF
N
P
1


W
EOF
b=`fdisk -l | grep '/dev/xvdb' |sed -n '2p' |awk  '{print $1}'`
mkfs.ext4  $b
    if [ $?  -eq 0 ] ;then
        if [ ! -d  /data  ];then
            mkdir /data
            UUID=`blkid $b  |awk -F ' ' '{print $2}'`
	    echo  "  $UUID       /data      ext4    defaults        0       0"  >>/etc/fstab
	    mount -a 
	        if [ $? -eq  0   ];then
    		    echo -e "\033[31m 磁盘挂载成功。\033[0m"
	        fi
        else
            echo "data is already existed."
            echo "plese check ."
            exit 1
        fi
    fi
else
      if [ $b != ${SYS_DIS%[[:digit:]]}  ];then 
          echo "${b} 和 ${SYS_DIS%[[:digit:]]}   不是同一块盘,可以初始化磁盘  "
 	     if [ -n $A  ];then
		 echo -e "\033[31m [Warning] "$0" 退出，因为, 数据盘可能已经初始化过了，或者没有数据盘"
		 echo -e "\033[0m "
     	     fi
      fi
fi



