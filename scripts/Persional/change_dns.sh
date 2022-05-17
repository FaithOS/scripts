#!/bin/bash
# 修改DNS  change_dns.sh 
# test1.sh
#apt-get install chrony -y 
#先让自己能出网，能ping通百度，要不无法下载unbound
echo 'nameserver 114.114.114.114' >>/etc/resolv.conf 

