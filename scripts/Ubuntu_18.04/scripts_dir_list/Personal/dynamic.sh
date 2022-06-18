#!/bin/bash
# 配置动态IP dynamic.sh
# 

# This is the network config written by 'subiquity'
#配置动态IP
cp -r /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml_backup
cat>/etc/netplan/00-installer-config.yaml<<EOF
network:
  ethernets:
        ens33:
           dhcp4: true
  version: 2
EOF
