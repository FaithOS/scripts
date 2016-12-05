#!/bin/bash
#
#判断当前系统

CU_install(){
USERA=secneo
PD_USER() {
if [ `id -u` -ne 0 ];then
    echo "This scripts must run with root !!!"
    exit 1
fi
}

DISABLED_ipv6(){
cat >> /etc/sysctl.conf<<EOF 
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

}

DISABLED_selinux(){
SE=`getenforce 0`
if [ ! -z $SE  ];then
if [ $SE != 'Permissive' -a  $SE != 'Disabled'   ];then
setenforce 0
sed -i  '7s/enforcing/disabled/' /etc/selinux/config 
fi
fi
}

DISABLED_ulimit(){
cat >>/etc/security/limits.conf<<EOF
* soft   nofile  65535
* hard nofile 65536
EOF
}

DISABLED_ipv6
DISABLED_selinux
DISABLED_ulimit
}



centos_add_user () {
    echo "##################添加用户$USERA######################"
    egrep "^sudo" /etc/group >& /dev/null
    if [ $? -ne 0 ];then
        groupadd sudo
    fi
    id $USERA 1>/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "$USERA already exists"
    else
        useradd -m $USERA -s /bin/bash
        usermod -G sudo $USERA
        id $USERA
    fi
}

centos_add_auth_key () {
    echo "##################添加认证用户######################"
    id $USERA 1>/dev/null 2>&1
    if [ $? -ne 0 ];then
        echo "please add a USERA $USERA first !"
    elif [ ! -d "/home/$USERA/.ssh" ];then
        mkdir /home/$USERA/.ssh
        cat >> /home/$USERA/.ssh/authorized_keys <<EOF
#kunlong.liu
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAt6TTxM4riWWuLru8XS+PedM1qX+/WxtW0tbsyy22RBVkLhO+7PiRmH3JGvRnmZwAbuTF+v8WQaSWEdE31Mi1UkydhYOQYrREbd2LqsDeEyJTS4RWeNtSSRlMlPOXDs9ahWv5R/0Dtx2CRu3DGzwTB2lgsvcbPkdnFO94gCZBwjU=
#pengpeng.shen
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAuJRLhMi5H7D6C12hIJK6nlXbKdAEJONRv3PKJZujXI1cfVmuwd52MFDVO5aOP2k/mBC8bigB8cPxkOf/l8DCTwwE3nUTDpyHrBKH6PzyyBlUy/FOV+DW+renVZAivrJWFW8nozxoE7tXw/pApBnW0O7HOUfGWm3GAcRPbPS2ON0=
#chengzhi.fan
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3jdVryUOZhkBfiUBZew1Al3KbIsbfs7t/0/W0jH4FN81LNHEFAHqN5xbEBU8nhPXXMhi/lAS/fKGPDoV6Kb/90b1wEjgtzH33ELps8nEcDBXlTzkujQZbcEUumbwxYL5DB6XxSE21ea5ZU/J6HfZhlsG6OlOOSYlU+ngUCJr9c4+al1qIvYXLZYF12i+5JVUYYP0AkFCCLrjOtqhWIRflnUWyPxYlXhAaFfOGExrFbiU1RH2smwsoFALj3WklmjKyaXXX03/NDVwA2ICF3vLdBzRXeNTKtrSxH+P2I2XgKjxyGAfthosSgN276lJ4ndSDTpbMW0ObtXLC6IsoR+4iQ== root@localhost.localdomain
#liyujie
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA9EvK9hBKFs2mZRJnEwJi0RzpA/0/cXsNCoomHjT74B+9vkigAsdw4m+6KMEe+F4Gi6PoF/kZquj2J9S2wZcaKCYnCC/4y1CGi00JyhXy0kreS1y5HEZZh68pdAiFiroLUT2KbRcbqNSKU55bP6AnN6mQwoFv4aDRZ5s8+1Ne98E=
#jianguo.wang
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxv4VBDmEqd+5e56xkc6fDTjBXadP8oVSfOHB7ZDCwaLrzMKBrB76KI20sMp2jvSOMrBv8Igt6Lz4vcxSzxYk0POgeOBE01cmjqCh5brFNDELHpmHGnXmEsTQHxLfhKSc7ZQEorl0bBjpapwKrFawPJ7M8XClxivp82OcbfU1pCjz4qN7z73oG72fpfFowmnmvSOItuP0OoKNKmqiE0F6HgrHSRL7uu6f0AzWPjspwUUdpNJMW3rLk/Ze47WhfSnAo7Dbr3S6Hsb0XK574FqqKazRAeTRy7BZXw9OE4+mfZt/82ni9IUN7+jJQnXlvjRJ//vy2mkmXD8jaN9HWyY3Pw==
EOF
        chown -R $USERA.$USERA /home/$USERA/.ssh
	cat /home/$USERA/.ssh/authorized_keys
    else
	echo "authorized_keys file already exists"
    fi   
    echo "##################设置免密码sudo######################"
    echo "$USERA  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
#  sed -i 's/^#auth/auth/g' /etc/pam.d/su

}

centos_change_ssh_auth () {
     echo "##################更改ssh登录方式######################"
     /bin/cp -a /etc/ssh/sshd_config  /etc/ssh/sshd_config.bak
     sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
     sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
     sed -i 's/PasswordAuthentication yes/#PasswordAuthentication yes/g'  /etc/ssh/sshd_config
     sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 300/g ' /etc/ssh/sshd_config
     sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/g' /etc/ssh/sshd_config
cat >>/etc/ssh/sshd_config<< EOF
UseDNS no
AddressFamily inet
PermitRootLogin no
SyslogFacility AUTHPRIV
PasswordAuthentication no
EOF
    	service sshd restart
}

centos_change_yum_repo () {
    echo "##################修改yum源######################"
    REPO=`grep ^baseurl /etc/yum.repos.d/CentOS-Base.repo|head -n1|awk -F'/' '{print $3}'`
    if [ "$REPO" == "mirrors.aliyun.com" ];then
    	echo "yum repo is already update ,current is : mirrors.aliyun.com"
    else
    	mv /etc/yum.repos.d/CentOS-Base.repo{,.bak}
cat >>/etc/yum.repos.d/CentOS-Base.repo<<EOF
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#
 
[base]
name=CentOS-\$releasever - Base - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/
        http://mirrors.aliyuncs.com/centos/\$releasever/os/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=os
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6
 
#released updates 
[updates]
name=CentOS-\$releasever - Updates - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
        http://mirrors.aliyuncs.com/centos/\$releasever/updates/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=updates
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6
 
#additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
        http://mirrors.aliyuncs.com/centos/\$releasever/extras/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=extras
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6
 
#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/
        http://mirrors.aliyuncs.com/centos/\$releasever/centosplus/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6
 
#contrib - packages by Centos Users
[contrib]
name=CentOS-\$releasever - Contrib - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/contrib/\$basearch/
        http://mirrors.aliyuncs.com/centos/\$releasever/contrib/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=contrib
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6
EOF
    	yum clean all
    	yum makecache
    fi
if [ $? -eq 0 ];then
   yum install lrzsz dos2unix git vim sysstat iftop iotop tmux  unzip -y
fi
}


#===========start ubuntu============

ubuntu_add_user () {
    echo "##################添加用户$USERA######################"
    egrep "^sudo" /etc/group >& /dev/null
    if [ $? -ne 0 ];then
        groupadd sudo
    fi
    id $USERA 1>/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "$USERA already exists"
    else
        useradd -m $USERA -s /bin/bash
        usermod -G sudo $USERA
        id $USERA
    fi
}

ubuntu_add_auth_key () {
    echo "##################添加认证用户######################"
    id $USERA 1>/dev/null 2>&1
    if [ $? -ne 0 ];then
        echo "please add a user $USERA first !"
    elif [ ! -d "/home/$USERA/.ssh" ];then
        mkdir /home/$USERA/.ssh
cat >> /home/$USERA/.ssh/authorized_keys <<EOF
#kunlong.liu
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAt6TTxM4riWWuLru8XS+PedM1qX+/WxtW0tbsyy22RBVkLhO+7PiRmH3JGvRnmZwAbuTF+v8WQaSWEdE31Mi1UkydhYOQYrREbd2LqsDeEyJTS4RWeNtSSRlMlPOXDs9ahWv5R/0Dtx2CRu3DGzwTB2lgsvcbPkdnFO94gCZBwjU=
#pengpeng.shen
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAuJRLhMi5H7D6C12hIJK6nlXbKdAEJONRv3PKJZujXI1cfVmuwd52MFDVO5aOP2k/mBC8bigB8cPxkOf/l8DCTwwE3nUTDpyHrBKH6PzyyBlUy/FOV+DW+renVZAivrJWFW8nozxoE7tXw/pApBnW0O7HOUfGWm3GAcRPbPS2ON0=
#chengzhi.fan
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3jdVryUOZhkBfiUBZew1Al3KbIsbfs7t/0/W0jH4FN81LNHEFAHqN5xbEBU8nhPXXMhi/lAS/fKGPDoV6Kb/90b1wEjgtzH33ELps8nEcDBXlTzkujQZbcEUumbwxYL5DB6XxSE21ea5ZU/J6HfZhlsG6OlOOSYlU+ngUCJr9c4+al1qIvYXLZYF12i+5JVUYYP0AkFCCLrjOtqhWIRflnUWyPxYlXhAaFfOGExrFbiU1RH2smwsoFALj3WklmjKyaXXX03/NDVwA2ICF3vLdBzRXeNTKtrSxH+P2I2XgKjxyGAfthosSgN276lJ4ndSDTpbMW0ObtXLC6IsoR+4iQ== root@localhost.localdomain
#liyujie
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA9EvK9hBKFs2mZRJnEwJi0RzpA/0/cXsNCoomHjT74B+9vkigAsdw4m+6KMEe+F4Gi6PoF/kZquj2J9S2wZcaKCYnCC/4y1CGi00JyhXy0kreS1y5HEZZh68pdAiFiroLUT2KbRcbqNSKU55bP6AnN6mQwoFv4aDRZ5s8+1Ne98E=
#jianguo.wang
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxv4VBDmEqd+5e56xkc6fDTjBXadP8oVSfOHB7ZDCwaLrzMKBrB76KI20sMp2jvSOMrBv8Igt6Lz4vcxSzxYk0POgeOBE01cmjqCh5brFNDELHpmHGnXmEsTQHxLfhKSc7ZQEorl0bBjpapwKrFawPJ7M8XClxivp82OcbfU1pCjz4qN7z73oG72fpfFowmnmvSOItuP0OoKNKmqiE0F6HgrHSRL7uu6f0AzWPjspwUUdpNJMW3rLk/Ze47WhfSnAo7Dbr3S6Hsb0XK574FqqKazRAeTRy7BZXw9OE4+mfZt/82ni9IUN7+jJQnXlvjRJ//vy2mkmXD8jaN9HWyY3Pw==
EOF
        chown -R $USERA.$USERA /home/$USERA/.ssh
        cat /home/$USERA/.ssh/authorized_keys
    else
        echo "authorized_keys file already exists"
    fi
    echo "##################设置免密码sudo######################"
    echo "%sudo  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
}

ubuntu_change_ssh_auth () {
     echo "##################更改ssh登录方式######################"
     /bin/cp -a /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
 sed -i '/SyslogFacility AUTH/d' /etc/ssh/sshd_config
 sed -i '/PermitRootLogin without-password/d' /etc/ssh/sshd_config
cat >>/etc/ssh/sshd_config<<EOF
UseDNS no
AddressFamily inet
PermitRootLogin no
SyslogFacility AUTHPRIV
PasswordAuthentication no
EOF
        service ssh restart
}

ubuntu_change_apt_source () {
    echo "##################修改apt-get源######################"
    SOURCE=`egrep -v "^$|^#" /etc/apt/sources.list|head -n1|awk -F'/' '{print $3}'`
    if [ "$SOURCE" == "mirrors.aliyun.com" ];then
        echo "apt-get sources is already update ,current is : mirrors.aliyun.com"
    else
        mv /etc/apt/sources.list{,.bak}
cat >> /etc/apt/sources.list <<EOF
# 

# deb cdrom:[Ubuntu-Server 14.04 LTS _Trusty Tahr_ - Release amd64 (20140416.2)]/ trusty main restricted

#deb cdrom:[Ubuntu-Server 14.04 LTS _Trusty Tahr_ - Release amd64 (20140416.2)]/ trusty main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://mirrors.aliyun.com/ubuntu/ trusty universe
deb-src http://mirrors.aliyun.com/ubuntu/ trusty universe
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu 
## team, and may not be under a free licence. Please satisfy yourself as to 
## your rights to use the software. Also, please note that software in 
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://mirrors.aliyun.com/ubuntu/ trusty multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu trusty-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu trusty-security main restricted
deb http://mirrors.aliyun.com/ubuntu trusty-security universe
deb-src http://mirrors.aliyun.com/ubuntu trusty-security universe
deb http://mirrors.aliyun.com/ubuntu trusty-security multiverse
deb-src http://mirrors.aliyun.com/ubuntu trusty-security multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu trusty partner
# deb-src http://archive.canonical.com/ubuntu trusty partner

## Uncomment the following two lines to add software from Ubuntu's
## 'extras' repository.
## This software is not part of Ubuntu, but is offered by third-party
## developers who want to ship their latest software.
# deb http://extras.ubuntu.com/ubuntu trusty main
# deb-src http://extras.ubuntu.com/ubuntu trusty main
EOF
     apt-get update
    fi

}
centos_add_iptables(){
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

echo "+++++ display iptables rules +++++"
iptables -L -n
echo "+++++ set iptables default rules +++++"
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
echo "+++++ clean iptables rules +++++"
iptables -F
iptables -X
echo "+++++ init iptables rules +++++"
iptables -A INPUT -s 111.207.253.210/32 -j ACCEPT
iptables -A INPUT -s 42.62.59.208/28 -j ACCEPT
iptables -A INPUT -s 42.62.15.1/29 -j ACCEPT
iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
echo "+++++ display iptables rules +++++"
iptables -L -n
echo "+++++ compeleted +++++"
/etc/init.d/iptables save


}

ubuntu_add_iptables(){

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

echo "+++++ display iptables rules +++++"
iptables -L -n
EOF
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
echo "+++++ clean iptables rules +++++"
iptables -F
iptables -X
echo "+++++ init iptables rules +++++"
iptables -A INPUT -s 111.207.253.210/32 -j ACCEPT
iptables -A INPUT -s 42.62.59.208/28 -j ACCEPT
iptables -A INPUT -s 42.62.15.1/29 -j ACCEPT
iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
echo "+++++ display iptables rules +++++"
iptables -L -n

iptables-save > /etc/iptables.up.rules
        echo "pre-up iptables-restore < /etc/iptables.up.rules " >> /etc/network/interfaces
        echo "post-down iptables-save > /etc/iptables.up.rules" >> /etc/network/interfaces


}


INSTALL_Ubuntu() {
ubuntu_change_apt_source 
ubuntu_change_ssh_auth
ubuntu_add_auth_key
ubuntu_add_user
#ubuntu_add_iptables
}

INSTALL_CentOS (){
centos_add_user
centos_add_auth_key
centos_change_ssh_auth
centos_change_yum_repo
#centos_add_iptables
}

CU_install

SYSA=`cat /etc/issue | sed -n '1p' |awk '{print $1}'`
if [ $SYSA == CentOS -o $SYSA == Ubuntu  ];then
    if [[ $SYSA == CentOS  ]];then
        INSTALL_CentOS
    elif [[ $SYSA == Ubuntu  ]];then
        INSTALL_Ubuntu
    elif [[ $SYSB == CentOS   ]];then
        INSTALL_CentOS
    fi
else
   SYSB=`cat /etc/redhat-release | sed -n '1p' |awk '{print $1}'`
   if [[ $SYSB == CentOS  ]];then
       INSTALL_CentOS
       echo   CentOS7
   fi
fi
