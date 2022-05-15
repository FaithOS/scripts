#!/bin/bash
SELECT_LIST(){
	   read -p  "是否要对该系统进行操作(YES/NO) :" var

	   if [ $var == YES -o $var == yes  ];then
		   mkdir test	#创建目录用于存放脚本描述，脚本名称 的名单，
	   for  A in `ls ${OS_NAME_VERSION}`		#赋值A，为当前系统下的所有脚本名称
	   do 
		   sed -n '2p' ${OS_NAME_VERSION}/"$A" >>test/describe.txt		#将所有脚本的第二行内容打印到test/new.txt 文件内
	   done
		   cat -n test/describe.txt > test/describe_new.txt		#将文件内的所有内容增加行号， 为后面的
	   else 
		   echo "输入有误，退出"
		   exit 0
   	   fi

	  DESCRIBES=`awk  '{print $3}' test/describe_new.txt`   #将文件内的第三列为 脚本描述 全部定义到ZD 这个变量内，用于后面对比
	   PS3="请选择你要执行的数字,或者按0退出 :" 
	  
select  NUMM in `awk  '{print $3}' test/describe_new.txt`	#这里的NUMM 是中文的描述
	#	[ $NUMM -eq 0 ]   && break
	  # read -p "请选择你要执行的数字 :" NUM
do
	[ -z  $NUMM ] && echo '#########退出#########' && rm -rf test && exit 0  # 判断变量是否为空
	array=($DESCRIBES)				
	length=${#array[@]}		#确定变量的个数，然后根据变量个数进行对比 NUMM 的内容， 如果两个内容匹配就调用他的第三段脚本名
	for ((i=0; i<$length; i++))	#使用for循环对比每一个NUMM的值 是否与array「$i」相同，如果对比成功，
	do

	if [ $NUMM == "${array[$i]}" ]; then		#i是自增次数， 
		echo "正在执行脚本，请稍后......"
		# 如果NUMM等于array下标值，那么可以确定脚本表述，过滤脚本描述后面的脚本名称，给脚本名称重新赋值变量，然后再运行这个新赋值的变量（这里也就是脚本名称）
		implement_scripts=`grep "${array[$i]}"  test/describe.txt |awk -F "${array[$i]}" '{print $2}'`  #如果对比成功就讲这个值得第二列取出，
		cd ${OS_NAME_VERSION}

		bash ${implement_scripts}
		break 2
	fi
done
done
		rm -rf ../test
}
