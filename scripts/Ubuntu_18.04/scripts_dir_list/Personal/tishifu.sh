#!/bin/bash
# Ubuntu命令提示符 tishifu.sh
set -e
#
/bin/cp -r /root/.bashrc /root/.bashrc.backup
#sed -i  '21s/w/&]/g'  /etc/bash.bashrc
#sed -i  '21s/\}/&[/g'  /etc/bash.bashrc
sed -i '$a PS1=''"${debian_chroot:+($debian_chroot)}[\\u@\\h:\\w]\\$ "'' ' /root/.bashrc
source /root/.bashrc
color red  "提示符配置完毕,脚本执行成功  [ OK ] "
color red  "脚本执行完后 需要重新开启一个标签才能生效"
