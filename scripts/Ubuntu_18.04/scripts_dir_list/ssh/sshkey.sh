#!/bin/bash
# 秘钥分发配置	sshkey.sh
#
STAT=`curl -I -s 1www.baidu.com|grep HTTP|awk '{print $2}'`
[ -z $STAT ]&&STAT=200
if [ "200" -eq "$STAT" ];then
        action "THE WEB STATUS IS  ............ [OK]"
        exit 0
else
        action "THE WEB STATUS IS  ............ [FAILD]"
        exit 1
fi
echo 'sshkey 测试通过'
