#!/bin/bash
# 命令提示符 tishifu.sh

#shopt -s xpg_echo
echo  'export PS1='\'\[\\u\@\\h \\W\]\\\$' '\' >> /root/.bashrc
source /root/.bashrc
#echo "这是测试脚本"
#fuwuqi_info=`dmidecode|grep "System Information" -A9|egrep "Manufacturer|Product|Serial"`
#echo $fuwuqi_info
#a=($fuwuqi_info)
#echo $a
#b=${#fuwuqi_info[@]}	
#echo $b
