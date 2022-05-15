#!/bin/bash
#

  yum install python-setuptools -y
if [ $? -eq 0  ];then
    echo  ' python-setuptools 安装成功'
else
    echo 'python-setuptools 安装不成功'
    exit 0
fi

easy_install supervisor
if [ $? -eq 0  ];then
    echo  ' supervisor 安装成功'
else
    echo 'supervisor 安装不成功'
    exit 0
fi



#创建supervisor配置文件目录/etc/supervisor/
if [ !  -d /etc/supervisor ];then
mkdir -m 755  -p /etc/supervisor
mkdir -m 755 -p /etc/supervisor/conf.d
fi

#生成配置文件 
echo_supervisord_conf > /etc/supervisor/supervisord.conf

#修改supervisord.conf 配置文件，通过[include]配置项引用
echo '[include]' >> /etc/supervisor/supervisord.conf 
echo 'files = /etc/supervisor/conf.d/*.conf' >> /etc/supervisor/supervisord.conf

# 创建sersync 配置文件 
cat >> /etc/supervisor/conf.d/sersync.conf <<EOF
[program:sersync]
command = /usr/local/sersync/bin/sersync2 -r -o /usr/local/sersync/conf/confxml.xml
autostart = true     ; 在 supervisord 启动的时候也自动启动
startsecs = 5        ; 启动 5 秒后没有异常退出，就当作已经正常启动了
autorestart = true   ; 程序异常退出后自动重启
startretries = 3     ; 启动失败自动重试次数，默认是 3
user = root          ; 用哪个用户启动
redirect_stderr = true  ; 把 stderr 重定向到 stdout，默认 false
stdout_logfile_maxbytes = 20MB  ; stdout 日志文件大小，默认 50MB
stdout_logfile_backups = 20     ; stdout 日志文件备份数
stdout_logfile = /var/log/sersync_out.log
stderr_logfile = /var/log/sersync_err.log
[supervisord]
EOF


#启动supervisord
/usr/bin/python /usr/bin/supervisord

if [ $? -eq 0  ];then
    echo  ' supervisor 启动成功'
else
    echo 'supervisor 启动不成功'
    exit 0
fi
#判断sersync 是否启动
sersync_num=`ps aux  | grep  sersyncd  |wc -l`
if  [  $sersync_num -eq 2  ] ;then
    echo 'sersync 启动成功'
fi



