#!/bin/bash
# 个人使用优化 personal_list.sh
#

#Persional=PERSONALDIR
###新的菜单只需要替换 ${PERSONALDIR} 和Persional 相关的文件即可使用 
###二级菜单的环境变量 ${PERSONALDIR} 在文件check_OS.sh内定义  
PERSONAL_LIST(){
	 #  read -p  "是否要进行个性化设置(YES/NO) :" var
           echo "######################################"
	  # if [ $var == YES -o $var == yes  ];then
##########开始制作菜单
##
	      for  A in `ls ${PERSONALDIR}`		#查看目录下所有文件名并且赋值A，为当前系统下的所有脚本名称
		      
	      do 
		   sed -n '2p' ${PERSONALDIR}/"$A" >>${TMPDIR}/Persional_file.txt		#将所有脚本的第二行内容打印到test/new.txt 文件内
	      done
	   #else 
	#	   echo "输入有误，退出"
	#	   exit 0
   	 #  fi

	  DESCRIBES=`awk  '{print $2}' ${TMPDIR}/Persional_file.txt`   #将文件内的第三列为 脚本描述 全部定义到ZD 这个变量内，用于后面对比
	   PS3="请选择你要执行的数字,或者按0退出 :" 
	  
select  NUMM in $DESCRIBES	#这里的NUMM 是中文的描述
do
	[ -z  $NUMM ] && echo '#########退出#########' && rm -rf   ${TMPDIR}/Persional_file.txt && exit 0  # 判断变量是否为空
	array=($DESCRIBES)				
	length=${#array[@]}		#确定变量的个数，然后根据变量个数进行对比 NUMM 的内容， 如果两个内容匹配就调用他的第三段脚本名
	for ((i=0; i<$length; i++))	#使用for循环对比每一个NUMM的值 是否与array「$i」相同，如果对比成功，
	do

	if [ $NUMM == "${array[$i]}" ]; then		#i是自增次数， 
		echo "正在执行脚本，请稍后......"
		# 如果NUMM等于array下标值，那么可以确定脚本表述，过滤脚本描述后面的脚本名称，给脚本名称重新赋值变量，然后再运行这个新赋值的变量（这里也就是脚本名称）
		implement_scripts=`grep "${array[$i]}"  ${TMPDIR}/Persional_file.txt |awk -F "${array[$i]}" '{print $2}'`  #如果对比成功就讲这个值得第二列取出，
		cd ${PERSONALDIR}

		bash ${implement_scripts}
		break 2
	fi
done
done
##制作菜单返回，先删除之前的菜单，防止菜单冲去
		rm -rf ${TMPDIR}/Persional_file.txt
		#再次执行菜单，以达到菜单循环的效果
		PERSONAL_LIST
}
PERSONAL_LIST
