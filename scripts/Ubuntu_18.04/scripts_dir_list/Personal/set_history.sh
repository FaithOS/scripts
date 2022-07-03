#/bin/bash
# 设置历史命令执行时间 set_history.sh

# chmod o+w 表示 普通用户也有对该文件写的权限，这样普通用户的操作也能被记录到该文件内，缺点：普通用户可以修改该文件
#历史命令记录日志
#禁止cat 解析变量
#cat >/etc/bash.bashrc<<-"EOF"
  [  ! -f  /var/log/history.log ] && touch /var/log/history.log
cat >/etc/profile.d/history.sh<<-"EOF"
###记录历史命令
export HISTORY_FILE=/var/log/history.log #自定义历史命令保存文件
my_ip=`who am i |awk -F '[()]'  '{print $2}' `
my_pts=`who i am |awk '{print $2}'`
export PROMPT_COMMAND=' { date "+%Y-%m-%d %T  - IP:"$my_ip" - PS:"$my_pts" - ["$USER"@"$HOSTNAME":`pwd` ]: $(history 1 | { read x cmd; echo "$cmd"; })"; } >> "$HISTORY_FILE"'
EOF
#多终端同时记录
#shopt -s histappend
#实时追加命令记录到文件内
PROMPT_COMMAND=”history -a”
#在脚本内使用bash 生效环境变量， 当前标签不生效， 需要重新打开一个新的标签就会生效了
bash /etc/profile.d/history.sh
#防止普通用户删除或查看日志文件
chmod 642 $HISTORY_FILE
echo "历史命令设置完毕，当前标签不生效， 需要重新打开一个新的连接标签就会生效."
