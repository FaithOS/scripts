#/bin/bash
CHECK_USER(){

if [ `id -u` -ne 0 ];then
    echo "This scripts must run with root !!!"
fi
}
CHECK_USER
