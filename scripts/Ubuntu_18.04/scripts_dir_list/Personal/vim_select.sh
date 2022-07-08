#!/bin/bash
# VIM设置 vim_select.sh
#
#set -e 

##三级菜单变量
#VIM,只需要将所有的VIM 替换成新的服务器名称即可
 ###新的菜单只需要替换 ${VIMDIR} 和Persional 相关的文件即可使用 
###二级菜单的环境变量 ${VIMDIR} 在文件check_OS.sh内定义  
VIM_LIST(){
echo "######################################"
##########开始制作菜单
for A in `ls ${VIMDIR}`	
   do 
      sed -n '2p' ${VIMDIR}/"$A" >>${TMPDIR}/VIM_file.txt
done
######菜单返回功能
echo 3 >${TMPDIR}/there_list_pid.txt
DESCRIBES=`awk  '{print $2}' ${TMPDIR}/VIM_file.txt`  
PS3="请选择你要执行的数字,或者按0退出 :" 
######打印菜单	  
select  NUMM in $DESCRIBES
do
    [ -z  $NUMM ] && echo '#########退出#########' && rm -rf   ${TMPDIR}/VIM_file.txt   && exit 0  
    array=($DESCRIBES)				
    length=${#array[@]}	
    for ((i=0; i<$length; i++))	
	do
	if [ $NUMM == "${array[$i]}" ]; then	
	    echo "正在执行脚本，请稍后......"
	    implement_scripts=`grep "${array[$i]}"  ${TMPDIR}/VIM_file.txt |awk -F "${array[$i]}" '{print $2}'` 
	    cd ${VIMDIR}
	    bash ${implement_scripts}
	    #echo 2 >${TMPDIR}/there_list_pid.txt
	    break 2
	fi
     done
done
##制作菜单返回，先删除之前的菜单，防止菜单冲去
		#再次执行菜单，以达到菜单循环的效果
		CLEAN
		VIM_LIST
}
VIM_LIST
