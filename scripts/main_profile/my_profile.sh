#!/bin/bash
MY_PROFILE(){
export OS_NAME=`awk -F '"' '/^NAME/{print $2}' /etc/os-release|awk -F ' ' '{print $1}'`
export OS_VERSION=`awk -F '=|"' '/^VERSION_ID/{print $3}' /etc/os-release`
export OS_NAME_VERSION=${OS_NAME}_${OS_VERSION}
#网卡检查
export INTER_NAME=`ip addr  | awk  -F '2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
export INTER_IPS=`ip addr | grep  "$INTER_NAME" | awk -F 'inet | brd' ' {print $2}'|sed -n 2p`
export INTER_IP=`ip addr  | grep  "$INTER_NAME" | awk -F ' '  '/inet / {print $2}' |awk -F '/' '{print $1}'`
export GATEWAY=`route -n  | grep UG |awk '{print $2}'`
echo "当前系统 $OS_NAME_VERSION"
#通用变量
export PWD=`pwd`
export SDL=${OS_NAME_VERSION}/scripts_dir_list
export TMPDIR=${PWD}/tmp
#函数继承
export -f action			
#二级菜单变量
export PERSONALDIR=${PWD}/${SDL}/Personal
export SSHDIR=${PWD}/${SDL}/ssh
#三级菜单变量
export VIMDIR=${PERSONALDIR}/VIM
}
