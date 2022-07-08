#!/bin/bash
# Ubuntu命令提示符 tishifu.sh
set -e
#
/bin/cp -r /etc/bash.bashrc /etc/bash.bashrc.backup
sed -i  '21s/w/&]/g'  /etc/bash.bashrc
sed -i  '21s/\}/&[/g'  /etc/bash.bashrc
echo -e "\033[31m  "提示符配置完毕" \033[0m"  "\033[32m 脚本执行成功  [ OK ] \033[0m"
echo -e "\033[31m  "在本地执行手动  source /etc/bash.bashrc  后生效" \033[0m"
