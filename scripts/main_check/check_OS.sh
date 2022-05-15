#!/bin/bash
CHECK_OS(){
OS_NAME=`awk -F '"' '/^NAME/{print $2}' /etc/os-release`
OS_VERSION=`awk -F '=|"' '/^VERSION_ID/{print $3}' /etc/os-release`
OS_NAME_VERSION=${OS_NAME}_${OS_VERSION}
echo "当前系统 $OS_NAME_VERSION"
}
