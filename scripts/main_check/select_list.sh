#!/bin/bash
SELECT_LIST(){
	   read -p  "是否要对该系统进行操作(YES/NO) :" var

	   if [ $var == YES -o $var == yes  ];then
		   mkdir test
	   for  A in `ls ${OS_NAME}`
	   do 
		   sed -n '2p' ${OS_NAME}/"$A" >>test/new.txt
	   done
		   cat -n test/new.txt > test/new_new.txt
	   else 
		   echo "输入有误，退出"
		   exit 0
   	   fi

	  ZD=`awk  '{print $3}' test/new_new.txt`
	   PS3="请选择你要执行的数字,或者按0退出 :" 
	  
select  NUMM in `awk  '{print $3}' test/new_new.txt`
	#	[ $NUMM -eq 0 ]   && break
	  # read -p "请选择你要执行的数字 :" NUM
do
	echo ‘####################### $NUMM’
	array=($ZD)
	length=${#array[@]}
	for ((i=0; i<$length; i++))
	do

	if [ $NUMM == "${array[$i]}" ]; then
		echo "Congratulations, you are my good firend!"
		# 如果NUMM等于array下标值，那么可以确定脚本表述，过滤脚本描述后面的脚本名称，给脚本名称重新赋值变量，然后再运行这个新赋值的变量（这里也就是脚本名称）
		zhixing_scripts=`grep "${array[$i]}"  test/new.txt |awk -F "${array[$i]}" '{print $2}'`
		cd ${OS_NAME}
		bash ${zhixing_scripts}
		break 2
	fi
done
done
		rm -rf ../test
}
