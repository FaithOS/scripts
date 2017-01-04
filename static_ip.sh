#!/bin/bash

# Author   : Faith
# Revision : 10
# Date     : 2011-06-03 14:36 PDT
#
# This script is provided as-is, and therefore has no warranty.  Use at your own risk
#
# Acknowledgments:
# Richard Marshall  - Continously helping review my code, and provide more one-liner
#                     answers and general code improvement suggestions
# Jonathan Campbell - Getting me back into coding
#
# Notes:
# This script will take your DHCP information and create a static configuration
# for both public and private network adapters (eth0 and eth1) on GoGrid Linux
# systems.
#
# Installation Notes:
# Save this file as /root/bin/convert_static.sh
# Make the file executable -
# [user@hostname]# chmod a+x /root/bin/convert_static.sh

# REQUIREMENT !!!
# You MUST modify the below variable to match your private network
#改为自己的掩码-我的是255.255.255.0，写前三位即可
NET="255.255.255"

# OPTIONAL !!!
# This script can perform a rDNS lookup on your public IP to set the right hostname.
# Set to 'change' if you have an rDNS for your public IP.  If you do not want your
# hostname to change via this script, leave this value 'unchanged'
HOSTNAME="unchanged"

[[ $NET == "0.0.0" ]] && exit 1

OS=`cat /etc/issue | sed 's/\(\w\) .*/\1/'`

case "$OS" in
	Red*)
		OS=RH
		;;
	Cen*)
		OS=RH
		;;
	Deb*)
		OS=Deb
		;;
	Ubu*)
		OS=Deb
		;;
	*)
		OS=Unknown
		;;
esac

# Make backups
BACKUPDIR=/root/`date +%F`-backup
[[ -d $BACKUPDIR || -f $BACKUPDIR ]]  && rm -rf $BACKUPDIR
mkdir $BACKUPDIR
[[ ! -d $BACKUPDIR ]] && exit 1

if [ -d /etc/sysconfig/network-scripts ] ; then
	NETCFG=/etc/sysconfig/network-scripts
	cp $NETCFG/ifcfg-eth0 $BACKUPDIR/ifcfg-eth0.bak
	cp $NETCFG/ifcfg-eth1 $BACKUPDIR/ifcfg-eth1.bak
	cp /etc/sysconfig/network $BACKUPDIR/network.bak
elif [ -d /etc/network ] ; then
	NETCFG=/etc/network
	cp $NETCFG/interfaces $BACKUPDIR/interfaces.bak
fi

cp /etc/resolv.conf $BACKUPDIR/resolv.bak
cp /etc/hosts $BACKUPDIR/hosts.bak

# Get netstat information
[[ -f /tmp/netstat.tmp ]] && rm -f /tmp/netstat.tmp
/bin/netstat -nar | grep eth0 > /tmp/netstat.tmp
sed -i '/169.254.0.0/d' /tmp/netstat.tmp

# MAC - Harvest MAC addresses for interfaces eth0 and eth1
[[ -f /tmp/eth0.mac.tmp ]] && rm -f /tmp/eth0.mac.tmp
[[ -f /tmp/eth1.mac.tmp ]] && rm -f /tmp/eth1.mac.tmp
/sbin/ifconfig eth0 | grep "HWaddr" | sed 's/.* HWaddr //' > /tmp/eth0.mac.tmp
/sbin/ifconfig eth1 | grep "HWaddr" | sed 's/.* HWaddr //' > /tmp/eth1.mac.tmp

# PUBLIC - Harvest the current public IP assigned by dhcp
[[ -f /tmp/eth0.ip.tmp ]] && rm -f /tmp/eth0.ip.tmp
/sbin/ifconfig eth0 | grep "inet addr" | sed 's/.* addr://;s/[ \t]* .*//' > /tmp/eth0.ip.tmp

# NETWORK - Harvest the network IP
[[ -f /tmp/eth0.network.tmp ]] && rm -f /tmp/eth0.network.tmp
cp /tmp/netstat.tmp /tmp/eth0.network.tmp
sed -i '/UG/d;s/[ \t]* .*//' /tmp/eth0.network.tmp

# GATEWAY - Harvest the gateway IP
[[ -f /tmp/eth0.gateway.tmp ]] && rm -f /tmp/eth0.gateway.tmp
cp /tmp/netstat.tmp /tmp/eth0.gateway.tmp
sed -i '/[1-9]* .* U .*/d;s/0.0.0.0[ \t]*//;s/[ \t]* .*//' /tmp/eth0.gateway.tmp

# NETMASK - Harvest the network netmask
[[ -f /tmp/eth0.netmask.tmp ]] && rm -f /tmp/eth0.netmask.tmp
/sbin/ifconfig eth0 | grep Mask | sed 's/.* Mask://' > /tmp/eth0.netmask.tmp

# ENDIP - Harvest the last octet of the public IP
[[ -f /tmp/eth0.lastoctet.tmp ]] && rm -f /tmp/eth0.lastoctet.tmp
cat /tmp/eth0.ip.tmp | sed 's/[0-9]*\.//g' > /tmp/eth0.lastoctet.tmp

# Assign variables the values harvested into temp files
HWADDR0=`cat /tmp/eth0.mac.tmp`
HWADDR1=`cat /tmp/eth1.mac.tmp`
PUBLIC0=`cat /tmp/eth0.ip.tmp`
GATEWAY=`cat /tmp/eth0.gateway.tmp`
NETWORK=`cat /tmp/eth0.network.tmp`
NETMASK=`cat /tmp/eth0.netmask.tmp`
LASTOCT=`cat /tmp/eth0.lastoctet.tmp`

if [ $OS = RH ] ; then
	/sbin/service network stop
	# Build new /etc/sysconfig/network-scripts/ifcfg-eth0
	[[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]] && rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
	cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<IFCFGETH0
DEVICE=eth0
BOOTPROTO=static
HWADDR=$HWADDR0
IPADDR=$PUBLIC0
NETMASK=$NETMASK
NETWORK=$NETWORK
GATEWAY=$GATEWAY
ONBOOT=yes
IFCFGETH0

	# Build new /etc/sysconfig/network-scripts/ifcfg-eth1
	[[ -f /etc/sysconfig/network-scripts/ifcfg-eth1 ]] && rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
	cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<IFCFGETH1
DEVICE=eth1
BOOTPROTO=static
HWADDR=$HWADDR1
IPADDR=$NET.$LASTOCT
NETMASK=255.255.255.0
NETWORK=$NET.0
ONBOOT=yes
IFCFGETH1

	# Build new /etc/sysconfig/network
	if [ $HOSTNAME == "change" ]; then
		HOSTNAME=`host $PUBLIC0 | sed -n '1 s/.*name pointer //;s/\.$//p'`
		case $HOSTNAME in
			*"gogrid.com"*)
				HOSTNAME=`cat $BACKUPDIR/network.bak | sed -n '/HOSTNAME/ s/HOSTNAME=//p'` ;;
			*"servepath.com"*)
				HOSTNAME=`cat $BACKUPDIR/network.bak | sed -n '/HOSTNAME/ s/HOSTNAME=//p'` ;;
			*)
				hostname $HOSTNAME
				echo $HOSTNAME > /proc/sys/kernel/hostname ;;
		esac

	else
		HOSTNAME=`cat $BACKUPDIR/network.bak | sed -n '/HOSTNAME/ s/HOSTNAME=//p'`
	fi

	[[ -f /etc/sysconfig/network ]] && rm -f /etc/sysconfig/network
	cat > /etc/sysconfig/network << CFGNETWORK
NETWORKING=yes
NETWORKING_IPV6=yes
GATEWAY=$GATEWAY
HOSTNAME=$HOSTNAME
CFGNETWORK

	/sbin/service network start
	cat $BACKUPDIR/resolv.bak | grep nameserver > /etc/resolv.conf
	sed -i '/convert_static/d' /etc/rc.local

elif [ $OS = Deb ] ; then
	/etc/init.d/networking stop
	sleep 1
	# Build new /etc/network/interfaces
	[[ -f /etc/network/interfaces ]] && rm -f /etc/network/interfaces
	cat > /etc/network/interfaces <<CFGINTERFACES
# This file describes network interfaces avaiulable on your system
# and how to activate them. For more information, see interfaces(5).
# Modified by convert_static.sh.
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address $PUBLIC0
hwaddress ether $HWADDR0
netmask $NETMASK
network $NETWORK
gateway $GATEWAY

auto eth1
iface eth1 inet static
address $NET.$LASTOCT
hwaddress ether $HWADDR1
netmask 255.255.255.0
network $NET.0
up route add -net 10.117.0.0 netmask 255.255.255.0 gw $NET.1
down route del -net 10.117.0.0 netmask 255.255.255.0 gw $NET.1
CFGINTERFACES

	# Build /etc/hosts
	if [ $HOSTNAME == "change" ]; then
		HOSTNAME=`host $PUBLIC0 | sed -n '1 s/.*name pointer //;s/\.$//p'`
		case $HOSTNAME in
			*"gogrid.com"*)
				HOSTNAME=`hostname` ;;
			*"servepath.com"*)
				HOSTNAME=`hostname` ;;
			*)
				hostname $HOSTNAME
				echo $HOSTNAME > /proc/sys/kernel/hostname
				rm -rf /etc/hosts
				echo -e "127.0.0.1\tlocalhost" > /etc/hosts
				SHORTHOST=`hostname | sed 's/\(\w\)\..*/\1/'`
				echo -e "127.0.1.1\t$HOSTNAME $SHORTHOST" >> /etc/hosts ;;
		esac

	else
		cp -f $BACKUPDIR/hosts.bak /etc/hosts
	fi

	/etc/init.d/networking start
	rm -rf /etc/resolv.conf
	cat $BACKUPDIR/resolv.bak | grep nameserver >> /etc/resolv.conf
	sed -i '/convert_static/d' /etc/rc.local

else
	echo "$OS is unsupported."; exit 1;
fi

# Remove temp files
rm -rf /tmp/*.tmp
