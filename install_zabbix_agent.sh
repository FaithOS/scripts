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
#cd $workdir
#wget http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.0.3/zabbix-3.0.3.tar.gz/download
#mv download zabbix-3.0.3.tar.gz
#tar zxvf zabbix-3.0.3.tar.gz
#./configure --enable-agent --prefix=/usr/local/zabbix-agent
sed -i "s/Server=127.0.0.1/Server=$zabbix_server_ip/p" /usr/local/zabbix_agent/zabbix_agentd.conf

cd $workdir
wget http://download.bangcle.net/linux/linuxsoft/zabbix/linux/zabbix-agent-3.0.3-compiled.tar.gz
tar xvf zabbix-agent-3.0.3-compiled.tar.gz
mv zabbix-agent-3.0.3 /usr/local
cd /usr/local
ln -sv zabbix-agent-3.0.3 zabbix-agent
sed -i "s/Hostname=/Hostname=$ip/g" /usr/local/zabbix-agent/etc/zabbix_agentd.conf
mkdir /var/log/zabbix
chown -R zabbix.zabbix /var/log/zabbix
cd $workdir
#ubuntu
if [ "$os_type" == "Ubuntu" ];then
cp conf/ubuntu/init.d/zabbix-agent /etc/init.d/zabbix-agent
update-rc.d zabbix-agent defaults
service zabbix-agent start
/usr/local/zabbix-agent/sbin/zabbix_agentd -c /usr/local/zabbix-agent/etc/zabbix_agentd.conf


#centos
elif [ "$os_type" == "CentOS" ];then
cp conf/centos/init.d/zabbix_agentd /etc/init.d/zabbix_agentd
chkconfig zabbix_agentd on
service zabbix_agentd start
fi

echo ' 192.168.138.35   zabbix.bangcle.net ' >> /etc/hosts
