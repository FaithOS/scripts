DHCP4=`grep 'dhcp4'  /etc/netplan/00-installer-config.yaml |awk -F  'dhcp4: ' '{print $2}' `
 [ "${DHCP4}" == 'no' ]  &&  exit 0 || echo haha
