#!/bin/bash
# 安装vsftp install_vsftp.sh

#!/bin/sh
#
PASSWD=`date |md5sum |head -c 16`
rpm -qa | grep  vsftp 
if [ $? -eq 0  ];then
   echo "vsftpd is exsits."
 exit 2
else
echo 'The vsftp is loading now, please wait ...'
   yum install vsftpd -y >>/dev/null
if [ $? -eq 0 ];then
   echo ''
elif [ -e  /etc/init.d/vsftpd ];then
   echo 'vsftpd start-up  file exsits'
else 
   echo 'vsfptd installed fail.'
 exit 3
fi
   id ctyunftp >/dev/null 2>&1 
if [ $? -ne 0   ];then
  useradd -s /sbin/nologin -d /home/ctyunftp ctyunftp
  echo "$PASSWD" |passwd --stdin ctyunftp  >>/dev/null
  echo "$PASSWD" >>/root/ctyunftp_passwd.txt
fi
  echo 'ctyunftp' >> /etc/vsftpd/chroot_list
  grep 'ctyunftp' /etc/vsftpd/chroot_list >/dev/null 2>&1 && systemctl  start vsftpd  || exit 4 
  chkconfig --add vsftpd
  chkconfig vsftpd on
fi
