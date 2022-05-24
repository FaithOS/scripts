#/bin/bash
# 设置历史命令执行时间 set_history.sh

# export HISTTIMEFORMAT="%F %T `who am i | awk '{ print $1 $5 }'` "
#历史命令记录日志
#禁止cat 解析变量
#cat >/etc/bash.bashrc<<-"EOF"
cat >/etc/profile.d/history.sh<<-"EOF"
###记录历史命令
export HISTORY_FILE=/var/log/history.log #自定义历史命令保存文件
[ -e "$HISTORY_FILE"  ]  && touch "$HISTORY_FILE" chmod o+w "$HISTORY_FILE"
export PROMPT_COMMAND=' { date "+%Y-%m-%d %T - USER:$USER IP:$SSH_CLIENT PS:$SSH_TTY - $(history 1 | { read x cmd; echo "$cmd"; })"; } >> "$HISTORY_FILE"'
EOF
#在脚本内使用bash 生效环境变量， 当前标签不生效， 需要重新打开一个新的标签就会生效了
bash /etc/profile.d/history.sh

echo "历史命令设置完毕，当前标签不生效， 需要重新打开一个新的连接标签就会生效."
