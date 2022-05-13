#!/bin/bash
#
wget http://download.bangcle.net/.wjg/sersync/sersync2.5.4_64bit_binary_stable_final.tar.gz -P /usr/local/
cd /usr/local
tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz
mv GNU-Linux-x86 /usr/local/sersync
cd /usr/local/sersync
mkdir /usr/local/sersync/bin
mkdir /usr/local/sersync/conf
mv /usr/local/sersync/sersync2  /usr/local/sersync/bin/
mv /usr/local/sersync/confxml.xml /usr/local/sersync/conf/
export PATH=$PATH:/usr/local/sersync/bin 
source /etc/profile

echo "vm@u7i8o9p0" > /etc/rsync.password
chmod 600 /etc/rsync.password 
#sersync2 -d -r -o /usr/local/sersync/conf/confxml.xml 
if [ -f /usr/local/sersync/conf/confxml.xml   ];then
mv /usr/local/sersync/conf/confxml.xml  /usr/local/sersync/conf/confxml.xml.bak
wget  http://download.bangcle.net/.wjg/sersync/confxml.xml -P /usr/local/
else
  echo  "sersync installed is fail."
fi


