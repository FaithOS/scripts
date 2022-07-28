#/bin/bash
# 设置历史命令执行时间 set_history.sh
set -e
# set -e :脚本执行错误会立刻退出
#历史命令记录日志
#1. 多用户记录操作命令
#2. 操作记录，记录在日志内
#3. 按执行时间、登入IP、登入终端方式、用户名、执行内容 进行记录
#4. 注意 交互式登入和非交互式登入 都要记录操作内容
#缺点
# 远程用户使用su - 普通用户 不会记录IP 但是可以通过日志来确认，因为使用root登入的时候会记录IP
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
#记录错误操作，记录空格起始的命令，默认HISTCONTROL 忽略这些内容了。
/bin/cp /root/.bashrc /root/.bashrc-set_history_backup
sed -i 's/HISTCONTROL/#&/' /root/.bashrc 
#实时追加命令记录到文件内
PROMPT_COMMAND="history -a"
#在脚本内使用bash 生效环境变量， 当前标签不生效， 需要重新打开一个新的标签就会生效了
bash /etc/profile.d/history.sh
#防止普通用户删除或查看日志文件
# chmod o+w 表示 普通用户也有对该文件写的权限，这样普通用户的操作也能被记录到该文件内，缺点：普通用户可以修改该文件
if [[ "$NUM_FILE"  -ne 0642   ]] ;then
chmod 642 /var/log/history.log
echo -e "\033[31m  "历史命令设置完毕，当前标签不生效， 需要重新打开一个新的连接标签就会生效." \033[0m"
fi
