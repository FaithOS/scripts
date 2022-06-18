#!/bin/bash
# 秘钥分发配置	sshkey.sh

#

EXPECT_INSTALL=`dpkg --get-selections | awk '/^expect/ {print $2}'`
if [ "$EXPECT_INSTALL" != install   ];then
    apt-get install expect -y 
fi
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

fi




cat "${TMPDIR}"/iplist|while read line 
do
SSH_CLIENT_IP=($line)
/usr/bin/expect<<EOF      
spawn   ssh-copy-id -i /root/.ssh/id_rsa.pub  root@$SSH_CLIENT_IP
set PWD "123123"     
expect {
"*yes/no" { send "yes\r"; exp_continue}
"*password:" { send "123123\r" } 
}
expect "#"
send "echo $SSH_CLIENT_IP is ok\r "
expect eof
EOF
if [ $? -eq 0 ];then
action "SSH_CLIENT_IP" /bin/true >> ${TMPDIR}/sucess_ip.txt
rm -rf ${TMPDIR}/iplist
else
action "SSH_CLIENT_IP" /bin/false >> ${TMPDIR}/false_ip.txt
fi
done
CLEAN
