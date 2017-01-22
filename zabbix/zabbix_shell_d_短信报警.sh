#
# Filename:    sendSMS.sh
# Revision:    1.0
# Date:        2015/08/27
# Author:	Faith
# Description: zabbix短信告警脚本

# 脚本的日志文件
LOGFILE="/tmp/SMS.log"
>"$LOGFILE"
exec 1>>"$LOGFILE"
exec 2>&1

# Uid 网站用户名
# Key 接口秘钥
Uid="itttl-user"
Key="itttl-passwd"

mobile=$1    # 手机号码
MESSAGE_UTF8=$3       # 短信内容
#MESSAGE_FUCK
#EOF`
XXD="/usr/bin/xxd"
CURL="/usr/bin/curl"
TIMEOUT=5

# 短信内容要经过URL编码处理，除了下面这种方法，也可以用curl的--data-urlencode选项实现。
MESSAGE_ENCODE=$(echo "$MESSAGE_UTF8" | ${XXD} -ps | sed 's/\(..\)/%\1/g' | tr -d '\n')
# SMS API
URL="http://x-chat-test.zmlearn.com:8080/api/user/zabbix-sms?OperID=${Uid}&OperPass=${Key}&SendTime=&ValidTime=&AppendID=0000&mobile=$1&content=${MESSAGE_ENCODE}"
# Send it
set -x
${CURL} -s --connect-timeout ${TIMEOUT} "${URL}

