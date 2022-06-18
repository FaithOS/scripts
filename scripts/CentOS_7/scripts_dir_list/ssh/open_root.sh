#!/bin/bash
# 开启root远程连接 open_root.sh
#
#备份文件
cp -r /etc/ssh/sshd_config /etc/ssh/sshd_config-dackup
echo 'PermitRootLogin yes' >>/etc/ssh/sshd_config
service sshd restart 
