#!/bin/bash
# 添加新服务 new_service.sh
set -e
read -p "请输入你要创建的名称，小写字母，不能有空格": new_name
echo ${SDL}
echo '#'
#添加二级菜单变量
sed -i '/SSHDIR/a\export '"${new_name}"'DIR=${scripts_DIR}/${SDL}/'"${new_name}"'' ${scripts_DIR}/main_profile/my_profile.sh
/bin/cp -r  ${scripts_DIR}/${OS_NAME_VERSION}/SSH_list.sh ${scripts_DIR}/${OS_NAME_VERSION}/${new_name}_list.sh
sed -i 's/SSH/'"${new_name}"'/g' ${scripts_DIR}/${OS_NAME_VERSION}/${new_name}_list.sh
mkdir  ${scripts_DIR}/${SDL}/${new_name}


cat >>${scripts_DIR}/${SDL}/${new_name}/test.sh<<-EOF
#!/bin/bash
# $「new_name}测试 test.sh
echo -e "\033[31m ${new_name} 配置成功 " \033[0m"
EOF
