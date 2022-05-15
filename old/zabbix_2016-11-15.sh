#!/bin/sh
#
DIR='/ctyun'
DIR_LNMP='/ctyun/lnmp'
if [  ! -d $DIR   ];then
   mkdir -p  "$DIR_LNMP"
fi
ZABBIX_HOST=`hostname`
MIRRORS (){
yum install  epel* -y  2>|1 >>/dev/null
if [ ! -f /etc/yum.repos.d/epel.repo.ctyun  ] ;then
cp  /etc/yum.repos.d/epel.repo  /etc/yum.repos.d/epel.repo.ctyun
sed -i 's/#//' /etc/yum.repos.d/epel.repo
sed -i 's/^m\(.*\)/#m\1/' /etc/yum.repos.d/epel.repo
cat >> /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/x86_64/ 
gpgcheck=0
enabled=1
EOF
fi
yum makecache
yum install -y  libaio* gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libpng libpng-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses curl curl-devel openssl-devel gdbm-devel db4-devel  libXpm-devel libX11-devel gd-devel gmp-devel readline-devel libxslt-devel expat-devel xmlrpc-c xmlrpc-c-devel   pcre pcre-devel openssl openssl-devel gmp-devel libc-client-devel
}

NGINX() {
wget http://mirrors.sohu.com/nginx/nginx-1.9.12.tar.gz -P /ctyun/lnmp
if [ $? -eq 0  ];then 
useradd www -s /sbin/nologin -M
tar xf /ctyun/lnmp/nginx-1.9.12.tar.gz -C /ctyun/lnmp/
cd /ctyun/lnmp/nginx-1.9.12
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module  --with-http_ssl_module
  if [ $? -eq 0  ];then 
    make && make install 
  else
    exit 2
  fi

cd ../
else
exit 1
fi
if [ ! -x /etc/init.d/nginxd  ] ;then

cat >> /etc/init.d/nginxd <<EOF
#!/bin/sh
#
# nginx - this script starts and stops the nginx daemin
#
# chkconfig:   - 85 15 
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse \
#               proxy and IMAP/POP3 proxy server
# processname: nginx
# config:      /usr/local/nginx/conf/nginx.conf
# pidfile:     /usr/local/nginx/logs/nginx.pid
# Source function library.
. /etc/rc.d/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ "\$NETWORKING" = "no" ] && exit 0
nginx="/usr/local/nginx/sbin/nginx"
prog=\$(basename \$nginx)
NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"
lockfile=/var/lock/nginx
start() {
    [ -x \$nginx ] || exit 5
    [ -f \$NGINX_CONF_FILE ] || exit 6
    echo -n \$"Starting \$prog: "
    daemon \$nginx -c \$NGINX_CONF_FILE
    retval=\$?
    echo
    [ \$retval -eq 0 ] && touch \$lockfile
    return \$retval
}
stop() {
    echo -n $"Stopping \$prog: "
    killproc \$prog -QUIT
    retval=\$?
    echo
    [ \$retval -eq 0 ] && rm -f \$lockfile
    return \$retval
}
restart() {
    configtest || return \$?
    stop
    start
}
reload() {
    configtest || return \$?
    echo -n \$"Reloading \$prog: "
    killproc \$nginx -HUP
    RETVAL=\$?
    echo
}
force_reload() {
    restart
}
configtest() {
  \$nginx -t -c \$NGINX_CONF_FILE
}
rh_status() {
    status \$prog
}
rh_status_q() {
    rh_status >/dev/null 2>&1
}
case "\$1" in
    start)
        rh_status_q && exit 0
        \$1
        ;;
    stop)
        rh_status_q || exit 0
        \$1
        ;;
    restart|configtest)
        \$1
        ;;
    reload)
        rh_status_q || exit 7
        \$1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo $"Usage: \$0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac
EOF
chmod +x /etc/init.d/nginxd 
 fi
mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.wjg
cat >> /usr/local/nginx/conf/nginx.conf << EOF
user  www www;
worker_processes  auto;
error_log  /usr/local/nginx/logs/error.log  crit;
pid        logs/nginx.pid;
events {
    use epoll;
    worker_connections  65535;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    log_format  commonlog  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                           '\$status \$body_bytes_sent "\$http_referer" '
                           '"\$http_user_agent" "\$http_x_forwarded_for"';
    sendfile        on;
    keepalive_timeout  65;
include vhost/*.conf;
}

EOF
mkdir /usr/local/nginx/conf/vhost
mkdir /home/www
cat >>/usr/local/nginx/conf/vhost/localhost.conf <<EOF
server {
    listen       81 default;
    server_name  localhost;
    index index.html index.htm index.php;
    root /home/www;
    location ~ .*\.(php|php5)?\$
    {
        #fastcgi_pass  unix:/tmp/php-cgi.sock;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi.conf;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)\$
    {
        expires 30d;
    }
    location ~ .*\.(js|css)?\$
    {
        expires 1h;
    }
    access_log  /usr/local/nginx/logs/access_log ;
}
EOF
/etc/init.d/nginxd restart 
 }

MYSQL (){
wget http://mirrors.ctyun.cn/tool/tools/mysql-5.6.27-linux-glibc2.5-x86_64.tar.gz  -P  $DIR_LNMP
useradd mysql -s /sbin/nologin -M
tar xf /ctyun/lnmp/mysql-5.6.27-linux-glibc2.5-x86_64.tar.gz -C $DIR_LNMP
ln -s /ctyun/lnmp/mysql-5.6.27-linux-glibc2.5-x86_64 /usr/local/mysql
mkdir -p /data/mysql/mysql3316/{data,logs,tmp} 
chown -R mysql.mysql /data/
cat >>/data/mysql/mysql3316/my3316.cnf <<EOF
[client]
port            = 3316
socket          = /tmp/mysql3316.sock
# The MySQL server
[mysqld]
# Basic
port            = 3316
user        = mysql
basedir         = /usr/local/mysql/
datadir         = /data/mysql/mysql3316/data
tmpdir          = /data/mysql/mysql3316/tmp
socket          = /tmp/mysql3316.sock
log-bin     = /data/mysql/mysql3316/logs/mysql-bin
log-error   = error.log
slow-query-log-file = slow.log
skip-external-locking
skip-name-resolve
log-slave-updates
###############################
# FOR Percona 5.6
#extra_port = 3345
gtid-mode = on
enforce-gtid-consistency=1
#thread_handling=pool-of-threads
#thread_pool_oversubscribe=8
explicit_defaults_for_timestamp
###############################
server-id       =763316
character-set-server = utf8
slow-query-log
binlog_format = row
max_binlog_size = 128M
binlog_cache_size = 1M
expire-logs-days = 5
back_log = 500
long_query_time=1
max_connections=1100
max_user_connections=1000
max_connect_errors=1000
wait_timeout=100
interactive_timeout=100
connect_timeout = 20
slave-net-timeout=30
max-relay-log-size = 256M
relay-log = relay-bin
transaction_isolation = READ-COMMITTED
performance_schema=0
#myisam_recover
key_buffer_size = 64M
max_allowed_packet = 16M
#table_cache = 3096
table_open_cache = 6144
table_definition_cache = 4096
sort_buffer_size = 128K
read_buffer_size = 1M
read_rnd_buffer_size = 1M
join_buffer_size = 128K
myisam_sort_buffer_size = 32M
tmp_table_size = 32M
max_heap_table_size = 64M
query_cache_type=0
query_cache_size = 0
bulk_insert_buffer_size = 32M
thread_cache_size = 64
#thread_concurrency = 32
thread_stack = 192K
skip-slave-start
# InnoDB
innodb_data_home_dir = /data/mysql/mysql3316/data
innodb_log_group_home_dir = /data/mysql/mysql3316/logs
innodb_data_file_path = ibdata1:100M:autoextend
innodb_buffer_pool_size = 100M
#innodb_buffer_pool_instances    = 8
#innodb_additional_mem_pool_size = 16M
innodb_log_file_size = 100M
innodb_log_buffer_size = 16M
innodb_log_files_in_group = 3
innodb_flush_log_at_trx_commit = 0
innodb_lock_wait_timeout = 10
innodb_sync_spin_loops = 40
innodb_max_dirty_pages_pct = 90
innodb_support_xa = 0
innodb_thread_concurrency = 0
innodb_thread_sleep_delay = 500
innodb_file_io_threads    = 4
innodb_concurrency_tickets = 1000
log_bin_trust_function_creators = 1
#innodb_flush_method = O_DIRECT
innodb_file_per_table
innodb_read_io_threads = 16
innodb_write_io_threads = 16
innodb_io_capacity = 2000
innodb_file_format = Barracuda
innodb_purge_threads=1
innodb_purge_batch_size = 32
innodb_old_blocks_pct=75
innodb_change_buffering=all
innodb_stats_on_metadata=OFF
[mysqld3316]
port                 = 3316
innodb_data_home_dir         = /data/mysql/mysql3316/data
datadir                = /data/mysql/mysql3316/data
innodb_log_group_home_dir     = /data/mysql/mysql3316/logs
tmpdir                  = /data/mysql/mysql3316/tmp
socket                  = /tmp/mysql3316.sock
log-bin                 = /data/mysql/mysql3316/logs/mysql-bin
innodb_buffer_pool_size     = 200M
[mysqldump]
quick
max_allowed_packet = 128M
#myisam_max_sort_file_size = 10G
[mysql]
no-auto-rehash
max_allowed_packet = 128M
prompt                         = '(product)\u@\h [\d]> '
default_character_set          = utf8
[myisamchk]
key_buffer_size = 64M
sort_buffer_size = 512k
read_buffer = 2M
write_buffer = 2M
[mysqlhotcopy]
interactive-timeout
[mysqld_safe]
#malloc-lib= /usr/local/mysql/lib/mysql/libjemalloc.so
EOF
echo 'PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile
source /etc/profile
cd /usr/local/mysql/
 ./scripts/mysql_install_db --defaults-file=/data/mysql/mysql3316/my3316.cnf >>/root/mysql_install.log
MySQL_install=`grep  -i '^OK$' /root/mysql_install.log  |uniq -c  |awk  '{print $1}'`
[[ $MySQL_install -eq 2  ]] && echo 'MySQL_install is ok' ||echo 'MySQL_install is fail '; rm -rf /root/mysql_install.log
mysqld --defaults-file=/data/mysql/mysql3316/my3316.cnf &

mysql_port=`netstat -lntp  | grep mysql| grep  -v grep | awk  -F ':' '{print $4}'`
declare -i mysql_port
if [ -n "$mysql_port" ] ;then
    echo ok
  elif [ "$mysql_port" -eq 3316  ];then
    echo 'mysql is running'
  else
    for ((a=0;a<=3;a++));do
mysql_port=`netstat -lntp  | grep mysql| grep  -v grep | awk  -F ':' '{print $4}'`
    sleep 5
    [[ $mysql_port -eq 3316 ]] && return || echo  'please waiting'

    done
fi


}

PHP () {
yum install -y gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libpng libpng-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses curl curl-devel openssl-devel gdbm-devel db4-devel  libXpm-devel libX11-devel gd-devel gmp-devel readline-devel libxslt-devel expat-devel xmlrpc-c xmlrpc-c-devel



wget http://mirrors.ctyun.cn/tool/.ctyun/tools/libiconv-1.14.tar.gz  -P ${DIR_LNMP}
sleep 2
cd ${DIR_LNMP}
tar zxf ${DIR_LNMP}/libiconv-1.14.tar.gz
cd ${DIR_LNMP}/libiconv-1.14
./configure --prefix=/usr/local/libiconv
if [ $? -eq 0 ];then
make && make install
if [ $? -eq 0 ];then
echo 'libiconv is ok'
else
echo 'libiconv is not ok'
exit 99
fi
else
echo "libiconv  configure is fail. "
exit 99
fi

cd ../

wget http://mirrors.ctyun.cn/tool/.ctyun/tools/libmcrypt-2.5.8.tar.gz -P ${DIR_LNMP}
sleep 2
cd ${DIR_LNMP}
tar zxf ${DIR_LNMP}/libmcrypt-2.5.8.tar.gz -C ${DIR_LNMP}
cd ${DIR_LNMP}/libmcrypt-2.5.8
./configure
if [ $? -eq 0 ];then
make && make install
if [ $? -eq 0 ];then
echo 'libmcrypt is ok'
else
echo 'libmcrypt is not ok'
exit 99
fi
else
echo "libmcrypt  configure is fail. "
exit 99
fi
sleep 2
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../../

wget http://mirrors.ctyun.cn/tool/.ctyun/tools/mhash-0.9.9.9.tar.gz -P ${DIR_LNMP}
sleep 2
cd ${DIR_LNMP}
tar zxf ${DIR_LNMP}/mhash-0.9.9.9.tar.gz -C ${DIR_LNMP}
cd ${DIR_LNMP}/mhash-0.9.9.9/
./configure
if [ $? -eq 0 ];then
make && make install
if [ $? -eq 0 ];then
echo 'mhash is ok'
else
echo "mhash is not ok"
exit 99
fi
else
echo "mhash  configure is fail. "
exit 99
fi
sleep 2
cd ../
rm -f /usr/lib/libmcrypt.*
rm -f /usr/lib/libmhash*
ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config


 wget http://mirrors.ctyun.cn/tool/.ctyun/tools/mcrypt-2.6.8.tar.gz -P ${DIR_LNMP}
sleep 2
cd ${DIR_LNMP}
tar xf ${DIR_LNMP}/mcrypt-2.6.8.tar.gz -C $DIR_LNMP
cd ${DIR_LNMP}/mcrypt-2.6.8 
ldconfig 
./configure
if [ $? -eq 0 ];then
make && make install
if [ $? -eq 0 ];then
echo 'mcrypt is ok'
else
echo "mcrypt is not ok"
exit 99
fi
else
echo "mcrypt  configure is fail. "
exit 99
fi



wget http://mirrors.ctyun.cn/tool/tools/php-5.6.15.tar.gz -P $DIR_LNMP
sleep 2
tar xf ${DIR_LNMP}/php-5.6.15.tar.gz -C  $DIR_LNMP
cd ${DIR_LNMP}/php-5.6.15
./configure  --prefix=/usr/local/php-5.6.15 \
--with-config-file-path=/usr/local/php-5.6.15/etc \
--with-bz2 \
--with-curl \
--enable-ftp \
--enable-sockets \
--disable-ipv6 \
--with-gd \
--with-jpeg-dir=/usr/local \
--with-png-dir=/usr/local \
--with-freetype-dir=/usr/local \
--enable-gd-native-ttf \
--with-iconv-dir=/usr/local \
--enable-mbstring \
--enable-calendar \
--with-gettext \
--with-libxml-dir=/usr/local \
--with-zlib \
--with-pdo-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-mysql=mysqlnd \
--enable-dom \
--enable-xml \
--enable-fpm \
--with-mhash \
--with-mcrypt \
--enable-fpm \
--with-libdir=lib64 \
--enable-bcmath

make && make install
ln -s /usr/local/php-5.6.15 /usr/local/php
echo  'PATH=/usr/local/php/bin:$PATH' >> /etc/profile
source /etc/profile
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
cp /ctyun/lnmp/php-5.6.15/php.ini-production /usr/local/php/etc/php.ini
cp /ctyun/lnmp/php-5.6.15/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
sed -i 's/user = nobody/user = www/g' /usr/local/php/etc/php-fpm.conf
sed -i 's/group = nobody/group = www/g' /usr/local/php/etc/php-fpm.conf
sed -i 's/;rlimit_files = 1024/rlimit_files = 51200/g' /usr/local/php/etc/php-fpm.conf
sed -i 's/^pm.max_children.*/pm.max_children = 300/g' /usr/local/php/etc/php-fpm.conf
/etc/init.d/php-fpm restart
}

ZABBIX24 (){
yum install net-snmp-devel -y
useradd -M -s /sbin/nologin zabbix
wget http://mirrors.ctyun.cn/tool/tools/zabbix-2.4.7.tar.gz -P $DIR_LNMP
cd $DIR_LNMP
tar xf zabbix-2.4.7.tar.gz -C $DIR_LNMP
mysql -S /tmp/mysql3316.sock -e "create database zabbix character set utf8;" 
mysql -S /tmp/mysql3316.sock -e "grant all on zabbix.* to zabbix@localhost identified by 'zabbix';"
cd ${DIR_LNMP}/zabbix-2.4.7/database/mysql 
mysql -S /tmp/mysql3316.sock zabbix < ${DIR_LNMP}/zabbix-2.4.7/database/mysql/schema.sql
mysql -S /tmp/mysql3316.sock zabbix < ${DIR_LNMP}/zabbix-2.4.7/database/mysql/images.sql 
mysql -S /tmp/mysql3316.sock zabbix < ${DIR_LNMP}/zabbix-2.4.7/database/mysql/data.sql
if [ $? -ne 0  ];then
exit 3
fi
cd ${DIR_LNMP}/zabbix-2.4.7
 ./configure \
--prefix=/usr/local/zabbix \
--enable-server \
--enable-proxy \
--enable-agent \
--with-mysql=/usr/local/mysql/bin/mysql_config \
--with-net-snmp \
--with-libcur

if [ $? -eq 0 ];then
  make
    if [ $? -eq 0 ];then
      make install
    else
      exit 2	
    fi
  else
    exit 1
fi


sed -i "s/;date.timezone =/date.timezone = Asia\/Shanghai/g" /usr/local/php-5.6.15/etc/php.ini 
sed -i "s#max_execution_time = 30#max_execution_time = 300#g" /usr/local/php-5.6.15/etc/php.ini 
sed -i "s#post_max_size = 8M#post_max_size = 32M#g" /usr/local/php-5.6.15/etc/php.ini 
sed -i "s#max_input_time = 60#max_input_time = 300#g" /usr/local/php-5.6.15/etc/php.ini 
sed -i "s#memory_limit = 128M#memory_limit = 128M#g" /usr/local/php-5.6.15/etc/php.ini 
sed -i "/;mbstring.func_overload = 0/ambstring.func_overload = 2\n" /usr/local/php-5.6.15/etc/php.ini 
sed -i 's/mbstring.func_overload = 2/mbstring.func_overload = 1/g' /usr/local/php-5.6.15/etc/php.ini
sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g' /usr/local/php-5.6.15/etc/php.ini
cp /usr/local/zabbix/etc/zabbix_server.conf /usr/local/zabbix/etc/zabbix_server.conf.ctyun
sed -i 's/DBUser=root/DBUser=zabbix/g' /usr/local/zabbix/etc/zabbix_server.conf 
sed -i "/# DBPassword=/aDBPassword=zabbix\n" /usr/local/zabbix/etc/zabbix_server.conf 
sed -i '/# DBSocket=\/tmp\/mysql.sock/a DBSocket=/tmp/mysql3316.sock\n' /usr/local/zabbix/etc/zabbix_server.conf 
sed -i '/# DBPort=3306/aDBPort=3316\n' /usr/local/zabbix/etc/zabbix_server.conf
cp ${DIR_LNMP}/zabbix-2.4.7/misc/init.d/fedora/core/zabbix_server /etc/init.d/ 
cp ${DIR_LNMP}/zabbix-2.4.7/misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
sed -i 's/BASEDIR=\/usr\/local/BASEDIR=\/usr\/local\/zabbix/g' /etc/init.d/zabbix_server
cp /usr/local/zabbix/etc/zabbix_agentd.conf /usr/local/zabbix/etc/zabbix_agentd.conf.ctyun
sed -i "s/Hostname=Zabbix server/Hostname="${ZABBIX_HOST}"/g" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i 's/BASEDIR=\/usr\/local/BASEDIR=\/usr\/local\/zabbix/g' /etc/init.d/zabbix_agentd
sed -i 's/mysqli.default_socket =/mysqli.default_socket =\/tmp\/mysql3316.sock/g' /usr/local/php-5.6.15/etc/php.ini
cp -a ${DIR_LNMP}/zabbix-2.4.7/frontends/php/* /home/www/
chown -R www.www /home/www
ln -s /ctyun/lnmp/mysql-5.6.27-linux-glibc2.5-x86_64/lib/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.18
/etc/init.d/php-fpm restart
/etc/init.d/zabbix_server start 
echo 'PATH=/usr/local/zabbix/bin:$PATH' >> /etc/profile
source /etc/profile
cat >> /root/zabbix-readme.txt << EOF
ip=localhost
port=3316
mysqldata=zabbix
user=admin
passwd=zabbix
EOF
}

Zabbix_client() {
read  -t 60 -p" please input zabbix_server IP:" IP
read  -t 60 -p" please input zabbix_server hostname:" ZABBIX_NAME
id zabbix >>/dev/null
if [ $? -ne 0  ];then
                                useradd -s /sbin/nologin -d /dev/null zabbix
                else
                        echo "zabbix is exits."
fi
                yum install gcc make -y
                wget http://mirrors.ctyun.cn/tool/tools/zabbix-2.4.7.tar.gz
tar xf zabbix-2.4.7.tar.gz
cd zabbix-2.4.7
./configure \
--prefix=/usr/local/zabbix-agent \
--enable-agent

if [ $? -ne 0 ];then
        echo 'zabbix installed is fail.'
        exit 1
else
        make && make install
fi

/bin/cp -a /root/zabbix-2.4.7/misc/init.d/fedora/core/zabbix_agentd /etc/init.d/zabbix_agentd
chown -R root.root /etc/init.d/zabbix_agentd
sed -i "s/Server=127.0.0.1/Server=$IP/g"  /usr/local/zabbix-agent/etc/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname="$ZABBIX_NAME"/g"  /usr/local/zabbix-agent/etc/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$IP/g"  /usr/local/zabbix-agent/etc/zabbix_agentd.conf
sed -i 's/BASEDIR=\/usr\/local/BASEDIR=\/usr\/local\/zabbix-agent/g' /etc/init.d/zabbix_agentd

cat >>/etc/services<<EOF
zabbix_agent 10050/tcp
zabbix_agent 10050/udp
zabbix_trap 10051/tcp
zabbix_trap 10051/udp
EOF

/etc/init.d/zabbix_agentd start
}

MIRRORS
NGINX 
MYSQL
PHP
ZABBIX24
#Zabbix_client
