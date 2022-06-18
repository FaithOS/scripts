#!/bin/bash
CLEAN(){

TMP_NUM=`ls -A "${TMPDIR}"|wc -l`
#if [[ -n ${TMP_NUM} ]];then
if [[ "${TMP_NUM}" -gt 1 ]];then
    tar cvf  /tmp/scripts_tmp_$(date +%H:%M:%S).tar.gz ./tmp/*  --remove-files ./tmp/* 
else
    echo "${TMPDIR} 目录下没有文件"
 retun=$?    
fi

#tar cvf  /tmp/scripts_tmp_$(date +%H:%M:%S).tar.gz ./tmp/*  --remove-files ./tmp/* 
}
