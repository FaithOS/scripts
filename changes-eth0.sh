#!/bin/sh
#
# 新服务器安装完系统后， 需要统一eth0 网卡名称。
# 该脚本只针对 centos7 服务器


ETH0=`ip addr  | awk  -F '2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
ATTR=`ip addr |grep -C 1 "$ETH0": |sed -n 3p |awk -F ' ' '{print $2}'`

if  [ $ETH0  == eth0  ];then
    echo "网卡为eth0 ， 不需要修改"    
    exit 0
fi

if [ -f  /etc/sysconfig/network-scripts/ifcfg-${ETH0}  ];then
mv /etc/sysconfig/network-scripts/ifcfg-${ETH0} /tmp
cat >> /etc/sysconfig/network-scripts/ifcfg-eth0<< EOF
TYPE=Ethernet
BOOTPROTO=static
IPADDR=172.16.31.x
NETMASK=255.255.255.0
GATEWAY=172.16.31.254
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
NAME=eth0
DEVICE=eth0
ONBOOT=yes
EOF

/bin/cp  /etc/default/grub  /etc/default/grub.bak
if [ -f  /etc/default/grub.bak  ];then
    sed -i 's/rhgb/net.ifnames=0 biosdevname=0 rhgb/g' /etc/default/grub 
    grub2-mkconfig -o /boot/grub2/grub.cfg
else
    echo  'grub 没有备份成功。'
    exit 0
fi


echo "SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*",ATTR{address}=="$ATTR",ATTR{type}=="1",KERNEL=="eth*",NAME=="eth0""    >/etc/udev/rules.d/70-persistent-net.rules 

else
    echo no
    exit 0
fi

route add  default gw 172.16.31.254
yum install net-tools -y 
service iptables stop
service firewall stop
setenforce 0
reboot 

