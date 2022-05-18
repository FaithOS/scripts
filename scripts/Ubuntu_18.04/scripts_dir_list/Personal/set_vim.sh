#!/bin/bash
# 设置vim粘贴格式  set_vim.sh
# 

#
#备要修改的文件
if [ !  -e /etc/vim/vimrc.local    ];then
touch /etc/vim/vimrc.local
echo '"设置vim粘贴格式' >>/etc/vim/vimrc.local
echo 'set paste' >> /etc/vim/vimrc.local
else
 /bin/cp -r /etc/vim/vimrc.local /etc/vim/vimrc.local-`date +%F`
echo '"设置vim粘贴格式' >>/etc/vim/vimrc.local
echo 'set paste' >> /etc/vim/vimrc.local
fi
echo "vim set is  ok " 
