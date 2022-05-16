#!/bin/bash
CHECK_OS(){
OS_NAME=`awk -F '"' '/^NAME/{print $2}' /etc/os-release`
OS_VERSION=`awk -F '=|"' '/^VERSION_ID/{print $3}' /etc/os-release`
OS_NAME_VERSION=${OS_NAME}_${OS_VERSION}
#网卡检查
INTER_NAME=`ip addr  | awk  -F '2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
INTER_IP=`ip addr | grep  ens33 | awk -F 'inet | brd' ' {print $2}'`
GATEWAY=`route -n  | grep UG |awk '{print $2}'`
echo "当前系统 $OS_NAME_VERSION"
}
