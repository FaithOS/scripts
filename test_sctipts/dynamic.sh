#!/bin/bash

# Author   : Faith
# Revision : 4
# Date     : 2010-03-12 23:48 PDT
# 
# This script is provided as-is, and therefore has no warranty.  Use at your own risk
#
# Notes:
# This script will take undo static IP configurations for RedHat/CentOS Linux
# systems.  In particular, this is designed to revert changes made by the
# script convert_static.sh
#
# 结合修改为静态的脚本，将其还原为动态IP配置
# Default backup location
BACKUPDIR=/root/`date +%F`-backup

if [ -d $BACKUPDIR ]; then
  COUNT=`ls -la $BACKUPDIR | wc -l`
  [[ $COUNT -ne 7 ]] && exit 1
else
  BACKUPDIR=`find /root -iname ifcfg-eth0.bak | sed 's/ifcfg-eth0.bak//'`
  [[ ! $BACKUPDIR ]] && exit 1
  COUNT=`ls -la $BACKUPDIR | wc -l`
  [[ $COUNT -ne 7 ]] && exit 1
fi

if [ $COUNT -eq 7 ]; then
  echo "Restoring backups from $BACKUPDIR"

  mv -f $BACKUPDIR/network.bak /etc/sysconfig/network
  mv -f $BACKUPDIR/ifcfg-eth0.bak /etc/sysconfig/network-scripts/ifcfg-eth0
  mv -f $BACKUPDIR/ifcfg-eth1.bak /etc/sysconfig/network-scripts/ifcfg-eth1
  mv -f $BACKUPDIR/resolv.bak /etc/resolv.conf

else
  # MAC - Harvest MAC addresses for interfaces eth0 and eth1
  [[ -f /tmp/ifcfg-eth0.mac.tmp ]] && rm -f /tmp/ifcfg-eth0.mac.tmp
  [[ -f /tmp/ifcfg-eth1.mac.tmp ]] && rm -f /tmp/ifcfg-eth1.mac.tmp
  /sbin/ifconfig eth0 | grep "HWaddr" | sed 's/.* HWaddr //' > /tmp/ifcfg-eth0.mac.tmp
  /sbin/ifconfig eth1 | grep "HWaddr" | sed 's/.* HWaddr //' > /tmp/ifcfg-eth1.mac.tmp
  HWADDR0=`cat /tmp/ifcfg-eth0.mac.tmp`
  HWADDR1=`cat /tmp/ifcfg-eth1.mac.tmp`

  cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<IFCFGETH0
DEVICE=eth0
BOOTPROTO=dhcp
HWADDR=$HWADDR0
ONBOOT=yes
IFCFGETH0

  cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<IFCFGETH1
DEVICE=eth1
BOOTPROTO=dhcp
HWADDR=$HWADDR1
ONBOOT=yes
IFCFGETH1

fi

rm -rf $BACKUPDIR /tmp/*.tmp

/sbin/service network restart
