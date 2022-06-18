#!/bin/bash
# 测试脚本 test.sh

echo "这是测试脚本"
fuwuqi_info=`dmidecode|grep "System Information" -A9|egrep "Manufacturer|Product|Serial"`
echo $fuwuqi_info
a=($fuwuqi_info)
echo $a
b=${#fuwuqi_info[@]}	
echo $b
