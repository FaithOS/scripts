#!/bin/bash
# 设置vim修改文件自动备份  set_vim.sh
# 

#
#备要修改的文件
if [   -e /etc/vim/vimrc.local    ]
echo ""设置修改文件自动产生备份" >> /etc/vim/vimrc.local
echo 'set backup ' >> /etc/vim/vimrc.local
fi
echo "vim set is  ok " 
