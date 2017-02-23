#!/bin/bash
#
#raid级别
level(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/RAID Level/) print $2}'|awk '{print $1}'
}
#磁盘总大小
size(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/^Size/) print $2}'
}

state(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/State/) print $2}'
}
strip_size(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/^Strip Size/) print $2}'
}
#磁盘总数
number_of_drives(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Number Of Drives/) print $2}'
}

span_depth(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Span Depth/) print $2}'
}
#默认缓存策略
Default_Cache_Policy (){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Default Cache Policy/) print $2}'
}
#当前缓存策略
Current_Cache_Policy(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Current Cache Policy/) print $2}'
}
Access_Policy(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Access Policy/) print $2}'
}       
Disk_Cache_Policy(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Disk Cache Policy/) print $2}'
}   
Encryption_Type(){
	sudo /usr/local/sbin/MegaCli -LDInfo -Lall -aALL | awk -F ":" '{if ($1~/Encryption Type/) print $2}'
}  
#报警监控
#磁盘类型
stype(){
MegaCli -pdlist -aALL |awk -F ':' '{if ($1~/PD Type/) print $0}' |awk BEGIN{RS=EOF}'{gsub(/\n/," ");print}'
}

strategy(){
	sudo /usr/local/sbin/MegaCli -LDGetProp -Cache -LALL -a0  |grep 'Cache Policy'|awk -F '[:,]' '{print $4}' 
}





$1


