#!/bin/bash
# 修改ubuntu解析  change_dns.sh 
# test1.sh
#apt-get install chrony -y 
#先让自己能出网，能ping通百度，要不无法下载unbound
echo 'nameserver 114.114.114.114' >>/etc/resolv.conf 

#ubuntu17.0之后特有，systemd-resolvd服务会一直覆盖

#解决办法

#sudo systemctl stop systemd-resolved
#sudo systemctl disable systemd-resolved

mv /etc/systemd/resolved.conf /etc/systemd/resolved.conf-backup
cat >/etc/systemd/resolved.conf<<-EOF
DNS=114.114.114.114
LLMNR=no
EOF

service systemd-resolved restart

DEFAUT_YUAN=114.114.114.114
YUAN=`systemd-resolve --status | awk -F ' ' '/DNS Servers:/ {print $3}' |sed -n 1p`
if [ $YUAN -eq $DEFAULT_YUAN  ];then
echo "resolv dns $YUAN is  ok   "
else
echo "resolv dns is failed"
fi




