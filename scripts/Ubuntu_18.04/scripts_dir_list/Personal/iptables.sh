#!/bin/bash
# iptables开放指定端口 iptables.sh

read -p "请输出你要开启的端口号:" IPTABLES_VAR
iptables -I INPUT -p tcp --dport "${IPTABLES_VAR}" -j ACCEPT
echo "端口 "${IPTABLES_VAR}"  开通完毕。"
