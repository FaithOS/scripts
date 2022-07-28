#!bin/bash
#安装zabbix-server install_zabbix-server.sh

set -e
echo "测试阶段 为完成" && exit 0


#定义变量
zabbix_ip=192.168.0.112

#修改主机名
#配置时间同步

#创建zabbix 用户

groupadd zabbix 
useradd -g  zabbix  zabbix  -s /sbin/nologin

#下载zabbix-server
wget https://cdn.zabbix.com/zabbix/sources/stable/4.0/zabbix-4.0.42.tar.gz -P  /usr/local/src/  # -P 指定下载路径

#安装依赖
apt-get install  apache2 apache2-bin apache2-data apache2-utils fontconfig-config fonts-dejavu-core fping libapache2-mod-php libapache2-mod-php7.2 libapr1 libaprutil1  libaprutil1-dbd-sqlite3 libaprutil1-ldap libfontconfig1 libgd3 libiksemel3 libjbig0 libjpeg-turbo8 libjpeg8 liblua5.2-0 libodbc1 libopenipmi0 libsensors4 libsnmp-base  libsnmp30 libsodium23 libssh2-1 libtiff5 libwebp6 libxpm4 php-bcmath php-common  php-gd php-ldap php-mbstring php-mysql php-xml php7.2-bcmath php7.2-cli php7.2-common  php7.2-gd php7.2-json php7.2-ldap php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline  php7.2-xml snmpd ssl-cert ttf-dejavu-core libmysqlclient-dev libxml2-dev libxml2 snmp  libsnmp-dev libevent-dev openjdk-8-jdk curl libcurl4-openssl-dev 

#安装mysql
 apt-get install mysql-server mysql-client  -y
#安装zabbix
cd /usr/local/src/
tar xf zabbix-4.0.42.tar.gz 
cd zabbix-4.0.42/
 ./configure --prefix=/apps/zabbinx-server --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --enable-java 
make && make install

#对数据库修改
mysql -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -e "create user zabbix@${zabbix_ip} identified by 'zabbix';"
mysql -e "grant all privileges on zabbix.* to zabbix@${zabbix_ip};"
#修改mysql配置文件
sed -i "s/bind-address		= 127.0.0.1/bind-address		= ${zabbix_ip}/g" /etc/mysql/mysql.conf.d/mysqld.cnf

......
#配置zabbix 前端
mkdir /var/www/html/zabbix
cd /usr/local/src/zabbix-4.0.42/frontends/php/
/bin/cp -a * /var/www/html/zabbix/ 

#修改php 时间




