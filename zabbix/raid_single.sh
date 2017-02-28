#!/bin/bash
#

iori=`MegaCli -cfgdsply -aALL  | grep -i Error |awk '{print $NF}' |wc -l`
sum=`MegaCli -cfgdsply -aALL  | grep -i Error |awk '{print $NF}' `
array=($sum)
for ((a=0;a<$iori;a++ ));do
b=${array[$a]} 
if [[ $b != 0  ]];then
 break
fi
done 
echo $b
