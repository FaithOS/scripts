#!/bin/bash
# 服务器互相通信 sshpass_key_2.sh
#********************************************************************
#Date: 			2021-07-26
#FileName：		sshpass.sh
#Description：		The test script
#Copyright (C): 	2021 All rights reserved
#********************************************************************

command 'action  脚本未完成！!!!!!!!!!!  /bin/false'
 action   退出当前脚本！!!!!!!!!!!!!!!!!!!!! /bin/ture
 exit 0




test {
if [ ! -e "${TMPDIR}/iplist"  ]
then
    echo "请创建${TMPDIR}/iplist， 并把要推送的客户端的IP写在里面"
elif  [ ! -e /root/.ssh/id_rsa.pub  ];then
    echo "请先创建公钥id_rsa.pub"
else
    echo '开始分发公钥，必须使用root用户，密码123123'
fi
    read -p '如果确定准备完毕请输入(YES|NO): ' var
if    [  $var == yes -o $var == YES  ];then
    echo "ok "
else  [  $var == no -o $var == NO  ]
    echo "退出"
   exit 0

fi

dpkg -l sshpass &> /dev/null || apt install sshpass
[ -f /root/.ssh/id_rsa ] || ssh-keygen -f /root/.ssh/id_rsa -P '123123'
export SSHPASS=1
cat "${TMPDIR}"/iplist|while read line 
do
SSH_CLIENT_IP=($line)
#for IP in $IPLIST;do
	sshpass -e ssh-copy-id -o StrictHostKeyChecking=no $line
done
}
