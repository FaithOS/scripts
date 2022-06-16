#!/bin/bash
# 克隆虚拟机后修改IP kvm_clone_ip.sh

#修改主机名
hostnamectl  set-hostname localhost
#获取源ip尾数
OLD_IP=`echo ${INTER_IP} |awk '{split($0,b,"[./]");print b[4]}'`

#修改网卡ip
cp -r /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml-backup
read -p "请输入新ip的最后一位,例如：109 ，请输入：" KVM_IP
sed -i "s/${OLD_IP}/${KVM_IP}/g" /etc/netplan/00-installer-config.yaml 
#####
NEW_IP=`grep addresses /etc/netplan/00-installer-config.yaml  |sed -n 1p |awk '{print $2}'`
echo "由于重启网卡后，IP 地址发生变更， 需要使用新的IP地址重新登入"
echo "新的IP 地址是：${NEW_IP}"
echo "三秒后重启网卡"
sleep 3
####重启网卡###
 netplan apply 

