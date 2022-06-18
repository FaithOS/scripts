#!/bin/bash
# 配置yum缓存安装包 yum_cache.sh

#备份配置文件
cp -r //etc/yum.conf /etc/yum.conf-`date +%F`-backup
#
sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf
