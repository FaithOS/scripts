#!/bin/bash
# 克隆虚拟机后修改内容 kvm_clone_ip.sh

#修改主机名
hostnamectl  set-hostname localhost
#修改网卡ip
cp -r /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml-backup
read -p "请输入新ip的最后一位,例如：109 " KVM_IP
sed -i "s/105/${KVM_IP}/g" /etc/netplan/00-installer-config.yaml 
