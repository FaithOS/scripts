#!/bin/bash
# 放弃本地修改强制更新 git.sh
git fetch --all
git reset --hard origin/master
git pull 
