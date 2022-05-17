#!/bin/bash
# 设置vim的tab键四个空格  set_vim_tab.sh
# 

#
#备要修改的文件
if [   -e /etc/vim/vimrc.local    ]
 /bin/cp -r /etc/vim/vimrc.local /etc/vim/vimrc.local-`date +%F`
echo '"设置vim的tab键四个空格' >>/etc/vim/vimrc.local
echo 'set paste\nset shiftwidth=4\set shiftwidth=4\n' >> /etc/vim/vimrc.local
fi
echo "vim set is  ok " 
