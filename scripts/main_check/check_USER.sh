#/bin/bash
CHECK_USER(){
#检查当前用户是否为root
if [ `id -u` -ne 0 ];then
    echo "This scripts must run with root !!!"
fi
}
CHECK_USER
