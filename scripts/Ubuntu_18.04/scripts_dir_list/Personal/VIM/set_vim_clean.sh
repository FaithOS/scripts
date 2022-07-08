#!/bin/bash
# 关闭vim清屏 set_vim_clean.sh

sed -i  '$a\export TERM=linux' ~/.bashrc
source ~/.bashrc
