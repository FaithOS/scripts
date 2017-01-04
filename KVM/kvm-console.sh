#!/bin/bash
#
#centos 6.x
INSTALL_CentOS (){
echo "ttyS0" >> /etc/securetty
sed -i '/quiet/ s/$/ console=ttyS0/' grub.conf
echo  'S0:12345:respawn:/sbin/agetty ttyS0 115200' /etc/inittab
reboot
}
#centos 7
INSTALL_CentOS7 (){
echo "ttyS0" >> /etc/securetty
echo "GRUB_TERMINAL=\"serial console\"
 GRUB_SERIAL_COMMAND=\"serial --speed=115200\"" >> /etc/default/grub
reboot
}

SYSA=`cat /etc/issue | sed -n '1p' |awk '{print $1}'`
if [ $SYSA == CentOS -o $SYSA == Ubuntu  ];then
    if [[ $SYSA == CentOS  ]];then
        INSTALL_CentOS
    elif [[ $SYSA == Ubuntu  ]];then
        INSTALL_Ubuntu
    elif [[ $SYSB == CentOS   ]];then
        INSTALL_CentOS
    fi
else
   SYSB=`cat /etc/redhat-release | sed -n '1p' |awk '{print $1}'`
   if [[ $SYSB == CentOS  ]];then
       INSTALL_CentOS7
       echo   CentOS7
   fi
fi
