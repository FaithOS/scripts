#!/bin/bash
# 时间同步 chrony_sync.sh

apt-get  install chronyd -y 
/bin/cp -r /etc/chrony/chrony.conf /etc/chrony/chrony.conf-`date +%F`
#注释掉之前的时间服务器
sed -i 's/pool/#pool/g' /etc/chrony/chrony.conf
#添加新的时间服务器
sed -i '21i pool s2c.time.edu.cn iburst' /etc/chrony/chrony.conf
###配置完后重启服务
systemctl restart  chronyd.service
####强制时间同步
chronyc -a makestep
#####修改时区
timedatectl set-timezone Asia/Shanghai
