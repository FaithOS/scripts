#/bin/bash
# 设置历史命令执行时间 set_history.sh

# export HISTTIMEFORMAT="%F %T `who am i | awk '{ print $1 $5 }'` "
#历史命令记录日志
#禁止cat 解析变量
cat >/etc/profile.d/history.sh<<-"EOF"
<<<<<<< HEAD
#HISTFILE=/vat/log/history.log 
=======
>>>>>>> fb0743aa2dc0a33c5386e5a1ab89823a2211b131
#由于bash的history文件默认是覆盖，如果存在多个终端，最后退出的会覆盖以前历史记录，改为追加形式
shopt -s histappend
###
HISTFILESIZE=4000            #默认保存命令是1000条，这里修改为4000条
HISTSIZE=4000
USER_IP=`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'` #取得登录客户端的IP
if [ -z $USER_IP ]
then
  USER_IP=`hostname`
fi
HISTTIMEFORMAT="%F %T $USER_IP:`whoami` "     #设置新的显示history的格式
export HISTTIMEFORMAT
EOF
#在脚本内使用bash 生效环境变量， 当前标签不生效， 需要重新打开一个新的标签就会生效了
bash /etc/profile.d/history.sh

echo "历史命令设置完毕，当前标签不生效， 需要重新打开一个新的连接标签就会生效."
