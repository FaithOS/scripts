#!/bin/bash
#
#本脚本主要给cobbler 安装后进行配置静态IP 和修改网卡为eth0


ETH0=`ip addr  | awk  -F '2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
ATTR=`ip addr |grep -C 1 "$ETH0": |sed -n 3p |awk -F ' ' '{print $2}'`
LOCAL_IP=`ifconfig  ${ETH0} | sed -n 2p |awk '{print $2}'`
LOCAL_NETMASK=`ifconfig  ${ETH0} | sed -n 2p |awk '{print $4}'`
LOCAL_GATEWAY=`netstat -r  | grep default |awk '{print $2}'`

INSTALL_ETH0 (){
if [ ${ETH0} != eth0  ];then
/bin/cp  /etc/default/grub  /etc/default/grub.bak
    if [ -f  /etc/default/grub.bak  ];then
        sed -i 's/rhgb/net.ifnames=0 biosdevname=0 rhgb/g' /etc/default/grub
        grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        echo  'grub 没有备份成功。'
    fi
    echo "SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*",ATTR{address}=="$ATTR",ATTR{type}=="1",KERNEL=="eth*",NAME=="eth0""    >/etc/udev/rules.d/70-persistent-net.rules
else
    echo no
fi
}


INSTALL_CentOS_6 (){

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ];then
   sudo   /bin/cp  /etc/sysconfig/network-scripts/ifcfg-eth0  /etc/sysconfig/network-scripts/ifcfg-eth0.`date +%F`
cat >/etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
BOOTPROTO=static
IPADDR=${LOCAL_IP}
NETMASK=${LOCAL_NETMASK}
GATEWAY=${LOCAL_GATEWAY}
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
NAME=eth0
DEVICE=eth0
ONBOOT=yes
EOF
fi

route add  default gw ${LOCAL_GATEWAY}
service network restart
cat >>  /etc/resolv.conf <<EOF
nameserver 114.114.114.114
EOF

}

INSTALL_CentOS_7 (){
###修改网卡为eth0
INSTALL_ETH0 

##配置静态IP
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ];then
   sudo   /bin/cp  /etc/sysconfig/network-scripts/ifcfg-eth0  /etc/sysconfig/network-scripts/ifcfg-eth0.`date +%F`
cat >/etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
BOOTPROTO=static
IPADDR=${LOCAL_IP}
NETMASK=${LOCAL_NETMASK}
GATEWAY=${LOCAL_GATEWAY}
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
NAME=eth0
DEVICE=eth0
ONBOOT=yes
EOF
fi 

route add  default gw ${LOCAL_GATEWAY}
service network restart 
cat >>  /etc/resolv.conf <<EOF
nameserver 114.114.114.114
EOF
###系统初始化
service iptables stop
service firewall stop
setenforce 0

}

INSTALL_Ubuntu (){
echo ''


}

OS=`cat /etc/issue | sed -n '1p' |awk '{print $1}'`

if [ $OS == CentOS -o $OS == Ubuntu  ];then
    if [[ $OS == CentOS  ]];then
        INSTALL_CentOS_6
        rm -rf $PWD/$0
    elif [[ $OS == Ubuntu  ]];then
        INSTALL_Ubuntu
        rm -rf $PWD/$0
    fi
else
   OS=`cat /etc/redhat-release | sed -n '1p' |awk '{print $1}'`
   if [[ $OS == CentOS  ]];then
       INSTALL_CentOS_7
   fi
fi


