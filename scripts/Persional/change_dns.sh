#!/bin/bash
# 修改ubuntu解析  change_dns.sh 
# test1.sh
#apt-get install chrony -y 
#先让自己能出网，能ping通百度，要不无法下载unbound
echo 'nameserver 114.114.114.114' >>/etc/resolv.conf 

#ubuntu17.0之后特有，systemd-resolvd服务会一直覆盖

#解决办法

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo apt install unbound
sudo rm -rf /etc/resolv.conf
sudo vim  /etc/NetworkManager/NetworkManager.conf

在[main]

下面添加

dns=unbound

将dns服务替换为unbound

reboot

重启电脑即可，开机查看resolve.conf发现nameserver自动配置


