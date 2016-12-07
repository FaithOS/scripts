#!/bin/bash
#author:kuilong.liu
#date:2016-06-20
#desc:install zabbix_agentd script

zabbix_server_ip=zabbix.bangcle.net
os_type=$(head -n1 /etc/issue|awk '{print $1}')
ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`	#zabbix_agent host ip
workdir=$(cd `dirname $0`;pwd)

groupadd zabbix
useradd -g zabbix zabbix

##complie zabbix_agentd src
cd $workdir
wget http://download.bangcle.net/linux/linuxsoft/zabbix/linux/zabbix-agent-3.0.3-compiled.tar.gz
tar xvf zabbix-agent-3.0.3-compiled.tar.gz
mv zabbix-agent-3.0.3 /usr/local
cd /usr/local
ln -sv zabbix-agent-3.0.3 zabbix-agent
# 替换zabbix clientIP  在disk脚本执行
#sed -i "s/Hostname=/Hostname=$ip/g" /usr/local/zabbix-agent/etc/zabbix_agentd.conf
mkdir /var/log/zabbix
chown -R zabbix.zabbix /var/log/zabbix
cd $workdir
#ubuntu
if [ "$os_type" == "Ubuntu" ];then
cp conf/ubuntu/init.d/zabbix-agent /etc/init.d/zabbix-agent


#centos
elif [ "$os_type" == "CentOS" ];then
cp conf/centos/init.d/zabbix_agentd /etc/init.d/zabbix_agentd
fi

echo ' 192.168.138.35   zabbix.bangcle.net ' >> /etc/hosts
