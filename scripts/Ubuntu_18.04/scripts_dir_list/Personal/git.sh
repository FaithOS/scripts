#!/bin/bash
# git放弃本地修改强制更新 git.sh
if [[ "${INTER_IP}" == '192.168.0.105'  ]] ;then
    echo "该操作无法在105机器上执行，"
else
git fetch --all
git reset --hard origin/master
git pull 
    echo "pull 拉取完成"
fi
