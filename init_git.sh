
basedir=$(cd `dirname $0`;pwd)
MY_github='https://FaithOS@github.com/FaithOS/scripts.git'
echo $basedir
git config --global user.name "Faith"
git config --global user.email 820007989@qq.com
if [  -f $basedir/.git/config   ];then
 /bin/cp $basedir/.git/config $basedir/.git/config_(`data` +%F).bak 
GITHUB=`grep github $basedir/.git/config  | awk '{print $3}'`
    if [ $MY_github == GITHUB  ];then 
        echo 'git is ok'
    else
        sed -i s/github.com/FaithOS@/g $basedir/.git/config
    fi
else
    echo 'git config file is not exist'
fi
