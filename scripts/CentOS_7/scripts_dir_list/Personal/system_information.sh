#!/bin/bash
# 系统信息 system_information.sh
ttt(){
#定义变量
fuwuqi_info=`dmidecode|grep "System Information" -A9|egrep "Manufacturer|Product|Serial"`

##系统安装时间
SYSTIME_INSTALL_TIME=`rpm -qi kernel |awk -F ':' '/Install Date/ {print $2}'`


##系统运行时间
SYSTEM_INFO_A=`uptime`
#系统磁盘大小分区情况

#系统内存大小

#系统当前负载情况

#系统当前几个用户登入，分别是谁
SYSTEM_USER=`w | awk -F ',' '{print $3}' |sed -n 1p`
#服务器名称

echo "服务器名称 "
#服务器设备号

#当前负载
SYSTEM_FUZAI=`w | awk -F 'load average:' '{print $2}' |sed -n 1p`

#系统版本
#系统内核版本
}
echo  '脚本未完成'
