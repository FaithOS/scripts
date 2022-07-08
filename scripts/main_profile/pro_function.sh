#!/bin/bash
CLEAN(){
# 由于在脚本内使用tar命令 中使用* 通配符， 在shell 执行流程上如果/tmp 路径下有多个文件 会被解析为 'file1' 'file2',这个多个文件， 里面的* 会被解释为'/tmp/*',导致通配符无法使用，所以定义成变量的方式来使用
filename_tmp="${TMPDIR}/*"
TMP_NUM=`ls -A "${TMPDIR}"|wc -l`
###在二级菜单设置一个执行值，不同的执行值 使用不同的删除方式，以后在写吧 tar cvf /tmp/* --exclude filename.txt ;使用exclude排除不想打包的文件
#FILE_NUM=`cat ${TMPDIR}/there_list_pid.txt`
if [[ "${TMP_NUM}" -gt 0 ]];then
# --remove-files  表示在/tmp 创建一个scripts_tmp的包， 并且删除 ./tmp 目录下被打包的源文件
  tar cf  /tmp/scripts_tmp_$(date +%H-%M-%S).tar.gz $filename_tmp  --remove-files $filename_tmp  >>/dev/null
else
    echo "${TMPDIR} 目录下没有文件"
fi

}
#让函数成为全局函数， 这样子进程脚本就可以继承这个函数了
export -f CLEAN

###颜色函数
#在脚本内调用 方式 color red ”输出内容“
#其中color 代替颜色， red代替了 echo -e 的效果，因为$1等于red 就执行 echo -e ”颜色“ ”输出内容“ ”RES“
color(){
RED_COLOR='\033[31m'
GREEN_COLOR='\033[32m'
YELLOW_COLOR='\033[33m'
BLUE_COLOR='\033[34m'
PINK='\033[35m'
RES='\033[0m'
if [ "$1" = "red" ];then
    echo -e "${RED_COLOR}$2 $RES"
elif [ "$1" = "green" ];then
    echo -e "${GREEN_COLOR}$2 $RES"
elif [ "$1" = "yellow" ];then
        echo -e "${YELLOW_COLOR}$2 $RES"
elif [ "$1" = "blue" ];then
        echo -e "${BLUE_COLOR}$2 $RES"
elif [ "$1" = "pink" ];then
    echo -e "${PINK}$2 $RES"
fi
}
export -f color
