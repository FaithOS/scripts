#!/bin/bash
CLEAN(){
# 由于在脚本内使用tar命令 中使用* 通配符， 在shell 执行流程上如果/tmp 路径下有多个文件 会被解析为 'file1' 'file2',这个多个文件， 里面的* 会被解释为'/tmp/*',导致通配符无法使用，所以定义成变量的方式来使用
filename_tmp="${TMPDIR}/*"
TMP_NUM=`ls -A "${TMPDIR}"|wc -l`
###在二级菜单设置一个执行值，不同的执行值 使用不同的删除方式，以后在写吧
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
