#/bin/bash
#########################################
#Function:    auto mount  disk
#Usage:       bash disk_2016-11-29.sh
#Author:      Faith
#OICQ：       820007989
#Blog：       jianguoa.wang
#Company:     XX
#Version:     1.0
#Date：       2016-11-30
#########################################
#该脚本适应于cenos 和ubuntu系统
PWD=`pwd`
SYS_DIS=`fdisk -l 2>&1 | egrep "^\/" |awk '{if ($2~/\*/) print $1 }'`
SYS_DIS_TWO=`df -h  | grep 'boot' |awk '{print $1}'`
DISK_SUM=(`lsblk -l | awk '{if ($6~/disk/) print $1}'`)
echo ====
if   [ ${SYS_DIS}  == $SYS_DIS_TWO  ] ;then
    echo  "确认系统盘为 ： ${SYS_DIS%[[:digit:]]} 。"
fi

A=`echo "${SYS_DIS%[[:digit:]]}"|awk -F '/' '{print $3}'`
##判断谁是数据盘
DISK_TOTL=`lsblk -l | awk '{if ($6~/disk/) print $1}'|wc -l`
for ((a=0;a<="$DISK_TOTL";a++));do
    if [ "${DISK_SUM[$a]}" != "$A" ];then
    B="${DISK_SUM[$a]}"
    BB=`fdisk -l 2>&1 | grep "${DISK_SUM[$a]}" |awk -F '[ :]' '{if($0~/\:/) print $2 }'`
##判断数据盘是否被格式化过
    DATA=`fdisk -l 2>&1 | grep "$B" |awk -F '[ :]' '{if($0~/\:/) print $2 }' |wc -l`
        if [ $DATA  -le 1  ];then
            echo "${BB} 是数据盘可以初始化。"
fdisk $BB <<EOF 2>&1
n
p
1


w
EOF
	    C=`fdisk -l 2>&1 | grep "${BB}[[:digit:]]" |awk '{print $1}'`
	    mkfs -t ext4 $C 2>&1
	    if [ $? -eq 0  ];then
		if [ ! -d /data"${a}"  ];then
		    mkdir /data"${a}"
		    UUID=`blkid "${C}"|awk -F ' ' '{print $2}'`
		    echo  "$UUID       /data$a      ext4    defaults        0       0"  >>/etc/fstab	   
		    mount -a 
			if [ $? -eq  0   ];then
    		    	    echo -e "\033[31m 磁盘挂载成功。\033[0m"
	        	fi
		fi
	    fi
        elif [ $a -eq $DISK_TOTL  ];then
            break
        else
            echo "${DISK_SUM[$a]}  已经初始化过了。"
	    
        fi
    fi
done
### 脚本执行完后自杀
rm -rf $PWD/$0

INSTALL_CentOS(){
cat >> /etc/rc.d/rc.local <<EOF
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local
EOF

}

INSTALL_Ubuntu(){
cat >>/etc/rc.local <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF

}

SYSA=`cat /etc/issue | sed -n '1p' |awk '{print $1}'`
if [ $SYSA == CentOS -o $SYSA == Ubuntu  ];then
    if [[ $SYSA == CentOS  ]];then
        INSTALL_CentOS
    elif [[ $SYSA == Ubuntu  ]];then
        INSTALL_Ubuntu
    elif [[ $SYSB == CentOS   ]];then
        INSTALL_CentOS
    fi
else
   SYSB=`cat /etc/redhat-release | sed -n '1p' |awk '{print $1}'`
   if [[ $SYSB == CentOS  ]];then
       INSTALL_CentOS
       echo   CentOS7
   fi
fi

