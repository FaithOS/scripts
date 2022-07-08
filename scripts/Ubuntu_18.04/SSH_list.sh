#!/bin/bash
# SSH服务 SSH_list.sh
#

#SSHDIR 这个变量定义在myprofile.sh文件
###新的菜单只需要替换 ${SSHDIR} 和SSH 相关的文件即可使用 
###二级菜单的环境变量 ${SSHDIR} 在文件check_OS.sh内定义  
#set -e 
##定义菜单函数
#CLEAN(){
# 由于在脚本内使用tar命令 中使用* 通配符， 在shell 执行流程上如果/tmp 路径下有多个文件 会被解析为 'file1' 'file2',这个多个文件， 里面的* 会被解释为'/tmp/*',导致通配符无法使用，所以定义成变量的方式来使用
#filename_tmp="${TMPDIR}/*"
#TMP_NUM=`ls -A "${TMPDIR}"|wc -l`
#if [[ "${TMP_NUM}" -gt 0 ]];then
# --remove-files  表示在/tmp 创建一个scripts_tmp的包， 并且删除 ./tmp 目录下被打包的源文件
#  tar cf  /tmp/scripts_tmp_$(date +%H-%M-%S).tar.gz $filename_tmp  --remove-files $filename_tmp
#else
#    echo "${TMPDIR} 目录下没有文件"
#fi

#}

SELECT_lista(){
  for A in `ls -al ${SSH_DIR} | grep "^-"  |awk '{print $9}'`          #查看目录下所有文件名并且赋值A，为当前系统下的所有脚本>名称
    do
      sed -n '2p' ${SSH_DIR}/"$A" >>${TMPDIR}/SSH_file.txt               #将所有脚本的第二行内容打印到test/new.txt 文件
  done 
}

SSH_LIST() {

    echo "######################################"
##########菜单返回后调用功能#########
echo 2 > ${TMPDIR}/there_list_pid.txt
THERE_FILE_NUM=$(cat  ${TMPDIR}/there_list_pid.txt)
if  [  "$THERE_FILE_NUM" -eq 2 ] ;then
    SELECT_lista
elif  [ "$THERE_FILE_NUM" -eq 3  ];then
    echo -e "\033[31m   "返回上一层" \033[0m"  #这里根本执行不到， 因为下面的clean 会删除there_list_pid.txt 这个文件。
    CLEAN
    SELECT_lista		#都执行的这个三级菜单，上面的if 下的select——lista 没有执行，以后写根据there_list_pid.txt内不同的值CLEAN 函数，做不同的操作，
fi
#####################
     DESCRIBES=`awk  '{print $2}' ${TMPDIR}/SSH_file.txt`   #将文件内的第三列为 脚本描述 全部定义到ZD 这个变量内，用于后面对比
     PS3="请选择你要执行的数字,或者按0退出 :" 
	  
select  NUMM in $DESCRIBES	#这里的NUMM 是中文的描述
do
    [ -z  $NUMM ] && echo '#########退出#########' && rm -rf   ${TMPDIR}/SSH_file.txt  && exit 0  # 判断变量是否为空
    array=($DESCRIBES)			
    length=${#array[@]}	#确定变量的个数，然后根据变量个数进行对比 NUMM 的内容， 如果两个内容匹配就调用他的第三段脚本名
    for ((i=0; i<$length; i++))	#使用for循环对比每一个NUMM的值 是否与array「$i」相同，如果对比成功，
	do
        if [ $NUMM == "${array[$i]}" ]; then		#i是自增次数， 
	    echo "正在执行脚本，请稍后......"
		# 如果NUMM等于array下标值，那么可以确定脚本表述，过滤脚本描述后面的脚本名称，给脚本名称重新赋值变量，然后再运行这个新赋值的变量（这里也就是脚本名称）
	    implement_scripts=`grep "${array[$i]}"  ${TMPDIR}/SSH_file.txt |awk -F "${array[$i]}" '{print $2}'`  #如果对比成功就讲这个值得第二列取出，
	    cd ${SSH_DIR}
	    bash ${implement_scripts}
	    break 2
	fi
    done
done
##制作菜单返回，先删除之前的菜单，防止菜单冲去
		#rm -rf ${TMPDIR}/SSH_file.txt
		# 清理tmp垃圾
	        CLEAN
		#再次执行菜单，以达到菜单循环的效果
		SSH_LIST

}
SSH_LIST
