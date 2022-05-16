#!/bin/bash
# 配置静态IP static_ip.sh 
# test1.sh
#apt-get install chrony -y 
echo "Ubuntu18.04 配置静态IP  测试ok"

cp -r /etc/netplan/00-installer-config.yaml  /etc/netplan/00-installer-config.yaml_`date +%F` 

cat > /etc/netplan/00-installer-config.yaml <EOF
network:
  ethernets:
    ${INTER_NAME}:
 	 dhcp4: no
  	 addresses: [ ${INTER_IP} ]
	 optional: true
  	 gateway4: ${GATEWAY}
 	 nameservers:
  		addresses: [114.114.114.114]
  version: 2
EOF

netplan try
