#!/bin/bash
# 配置静态IP static_ip.sh 
# test1.sh
#apt-get install chrony -y 
echo "Ubuntu18.04 配置静态IP  测试ok"

cp -r /etc/netplan/00-installer-config.yaml  /etc/netplan/00-installer-config.yaml_`date +%F` 
# EOF 格式
###cat >/file.txt<<-EOF #这里的-EOF 表述如果EOF 后面有空格也作为制表符，注意：EOF前后都不应有空格或其他符号。
###EOF
cat >/etc/netplan/00-installer-config.yaml<<-EOF
# This is the network config written by 'subiquity'
network:
  ethernets:
    ${INTER_NAME}:
      dhcp4: no
      addresses: [${INTER_IPS}]
      optional: true
      gateway4: $GATEWAY
      nameservers:
              addresses: [114.114.114.114]
  version: 2
EOF

netplan try
