#!/bin/bash
CHECK_OS(){

OS_NAME=`awk -F '"' '/^NAME/{print $2}' /etc/os-release`
OS_VERSION=`awk -F= '/^VERSION_ID/{print $2}' /etc/os-release`
echo "当前系统 $OS_NAME $OS_VERSION"
}
