#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pdb
import smtplib
import string
import time
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
#pdb.set_trace()
#HOST = "mail.gw.com.cn"
def S_Mail():
    HOST = "smtp.huanqiu.cn"                           
    SUBJECT = sys.argv[2].decode('utf-8').encode('gbk')   
    TO =sys.argv[1]                                       
    FROM = "ops@huanqiu.cn"
    text = sys.argv[3].decode('utf-8').encode('gbk')      
    BODY = string.join((
                    "FROM: %s" % FROM,
                    "To: %s"  % TO,
                    "Subject: %s" %SUBJECT,
                    "",
                    text
                    ),"\r\n")
    server = smtplib.SMTP()
    server.connect(HOST,25)
    #server.starttls()
    server.login("ops@huanqiu.cn","WEE78@12l$")
    server.sendmail(FROM,[TO],BODY)
    server.quit()
# email log 记录日志
    with open('/data/logs/zabbix/Email.log','a') as f:
        date=time.strftime("%y-%m-%d %H:%M:%S")
        str = date + "    " + TO +"    " + SUBJECT + "\r\n" + "\n"
        str1 = str.decode('gbk').encode('utf-8')
#       print("%s" %str1)
        f.write(str1)
if __name__=='__main__':
    S_Mail()
