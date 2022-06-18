#!/bin/bash
# 配置静态IP static_ip.sh


#备份配置文件

cp -r /etc/sysconfig/network-scripts/ifcfg-${INTER_NAME} /etc/sysconfig/network-scripts/ifcfg-${INTER_NAME}-`date +%F`.backup

cat >/etc/sysconfig/network-scripts/ifcfg-${INTER_NAME}<<EOF
DEVICE=${INTER_NAME}
BOOTPROTO=static
#HWADDR=$HWADDR1
IPADDR=${INTER_IP}
NETMASK=255.255.255.0
GATEWAY=${GATEWAY}
ONBOOT=yes
EOF
systemctl restart  network.service
