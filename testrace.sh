#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: testrace
# Version: 0.0.1
# Blog:   https://vpsxb.net
#======================================
${Font_suffix}"

check_system(){
	if   [[ ! -z "`cat /etc/issue | grep -iE "debian"`" ]]; then
		apt-get install traceroute mtr -y
	elif [[ ! -z "`cat /etc/issue | grep -iE "ubuntu"`" ]]; then
		apt-get install traceroute mtr -y
	elif [[ ! -z "`cat /etc/redhat-release | grep -iE "CentOS"`" ]]; then
		yum install traceroute mtr -y
	else
		echo -e "${Error} system not support!" && exit 1
	fi
}
check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}
directory(){
	cd /usr/local/bin
}
install(){
	[[ ! -f /usr/local/bin/nexttrace ]] && bash <(curl -Ls https://raw.githubusercontent.com/sjlleo/nexttrace/main/nt_install.sh)
	[[ ! -f /usr/local/bin/nexttrace ]] && echo -e "${Error} download failed, please check!" && exit 1
}



test_single_tcp(){
	echo -e "${Info} 请输入你要测试的目标 ip :"
	read -p "输入 ip 地址:" ip

	while [[ -z "${ip}" ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "输入 ip 地址:" ip
		done

	./nexttrace -T -q 1 -g cn ${ip} | awk '
        # 基础过滤：移除纯数字+*或纯*的行
        !/^[[:space:]]*[0-9]+[[:space:]]+\*[[:space:]]*$/ &&
        !/^[[:space:]]*\*[[:space:]]*$/ &&
        # 保留条件：包含IP、AS号、主机名或延迟时间
        (/([0-9]{1,3}\.){3}[0-9]{1,3}/ || /AS[0-9]+/ || /[a-zA-Z0-9-]+\.[a-zA-Z]/ || /[0-9.]+ ms/)
    '

	repeat_test_single_tcp
}
repeat_test_single_tcp(){
	echo -e "${Info} 是否继续测试其他目标 ip ?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_single
	while [[ ! "${whether_repeat_single}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_single
		done
	[[ "${whether_repeat_single}" == "1" ]] && test_single_tcp
	[[ "${whether_repeat_single}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}



test_alternative_tcp(){
	select_alternative_tcp
	set_alternative_tcp
	result_alternative_tcp
}
select_alternative_tcp(){
	echo -e "${Info} 选择需要测速的目标网络: \n1.中国电信\n2.中国联通\n3.中国移动\n4.教育网"
	read -p "输入数字以选择:" ISP

	while [[ ! "${ISP}" =~ ^[1-4]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" ISP
		done
}
set_alternative_tcp(){
	[[ "${ISP}" == "1" ]] && node_1
	[[ "${ISP}" == "2" ]] && node_2
	[[ "${ISP}" == "3" ]] && node_3
	[[ "${ISP}" == "4" ]] && node_4
}
node_1(){
	echo -e "1.上海电信\n2.上海CN2\n3.厦门CN2\n4.杭州电信\n5.嘉兴电信\n6.广州电信(天翼云)\n7.北京电信" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海电信"		&& ip=ipv4.sha-4134.endpoint.nxtrace.org
	[[ "${node}" == "2" ]] && ISP_name="上海CN2"		&& ip=ipv4.sha-4809.endpoint.nxtrace.org
	[[ "${node}" == "3" ]] && ISP_name="厦门CN2"		&& ip=117.28.254.129
	[[ "${node}" == "4" ]] && ISP_name="杭州电信"		&& ip=ipv4.hgh-4134.endpoint.nxtrace.org
	[[ "${node}" == "5" ]] && ISP_name="嘉兴电信"		&& ip=183.134.62.129
	[[ "${node}" == "6" ]] && ISP_name="广州电信"		&& ip=ipv4.can-4134.endpoint.nxtrace.org
	[[ "${node}" == "7" ]] && ISP_name="北京电信"		&& ip=ipv4.pek-4134.endpoint.nxtrace.org
}
node_2(){
	echo -e "1.广州联通\n2.北京联通\n3.杭州联通\n4.安徽合肥联通\n5.嘉兴联通\n6.上海联通\n7.上海联通9929" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="广州联通" 		&& ip=ipv4.can-4837.endpoint.nxtrace.org
	[[ "${node}" == "2" ]] && ISP_name="北京联通"		&& ip=ipv4.pek-4837.endpoint.nxtrace.org
	[[ "${node}" == "3" ]] && ISP_name="杭州联通" 		&& ip=ipv4.hgh-4837.endpoint.nxtrace.org
	[[ "${node}" == "4" ]] && ISP_name="安徽合肥联通" 	&& ip=112.122.10.26
	[[ "${node}" == "5" ]] && ISP_name="嘉兴联通" 		&& ip=60.12.95.255
	[[ "${node}" == "6" ]] && ISP_name="上海联通" 		&& ip=ipv4.sha-4837.endpoint.nxtrace.org
	[[ "${node}" == "7" ]] && ISP_name="上海联通9929" 	&& ip=ipv4.sha-9929.endpoint.nxtrace.org
}
node_3(){
	echo -e "1.上海移动\n2.深圳移动\n3.北京移动\n4.嘉兴移动\n5.杭州移动" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-5]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海移动" && ip=ipv4.sha-9808.endpoint.nxtrace.org
	[[ "${node}" == "2" ]] && ISP_name="广州移动" && ip=ipv4.can-9808.endpoint.nxtrace.org
	[[ "${node}" == "3" ]] && ISP_name="北京移动" && ip=ipv4.pek-9808.endpoint.nxtrace.org
	[[ "${node}" == "4" ]] && ISP_name="嘉兴移动" && ip=223.95.245.102
	[[ "${node}" == "5" ]] && ISP_name="杭州移动" && ip=ipv4.hgh-9808.endpoint.nxtrace.org
}
node_4(){
	ISP_name="北京教育网" && ip=101.4.117.213
}
result_alternative_tcp(){
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./nexttrace -T -q 1  -g cn ${ip} | awk '
        # 基础过滤：移除纯数字+*或纯*的行
        !/^[[:space:]]*[0-9]+[[:space:]]+\*[[:space:]]*$/ &&
        !/^[[:space:]]*\*[[:space:]]*$/ &&
        # 保留条件：包含IP、AS号、主机名或延迟时间
        (/([0-9]{1,3}\.){3}[0-9]{1,3}/ || /AS[0-9]+/ || /[a-zA-Z0-9-]+\.[a-zA-Z]/ || /[0-9.]+ ms/)
    '
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"

	repeat_test_alternative_tcp
}
repeat_test_alternative_tcp(){
	echo -e "${Info} 是否继续测试其他节点?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_alternative
	while [[ ! "${whether_repeat_alternative}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_alternative
		done
	[[ "${whether_repeat_alternative}" == "1" ]] && test_alternative_tcp
	[[ "${whether_repeat_alternative}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}



test_all_tcp(){
	result_all_tcp	'ipv4.sha-4134.endpoint.nxtrace.org'	'上海电信'
	result_all_tcp	'ipv4.sha-4809.endpoint.nxtrace.org'	'上海CN2'
	result_all_tcp	'ipv4.sha-4837.endpoint.nxtrace.org'   	'上海联通'
     	result_all_tcp	'ipv4.sha-9929.endpoint.nxtrace.org'   	'上海联通9929'
	result_all_tcp	'ipv4.sha-9808.endpoint.nxtrace.org'	'上海移动'
	result_all_tcp	'ipv4.can-9808.endpoint.nxtrace.org'	'广州移动'
	result_all_tcp	'ipv4.hgh-4538.endpoint.nxtrace.org'	'杭州教育网'

	echo -e "${Info} 四网路由快速测试 已完成 ！"
}
result_all_tcp(){
	ISP_name=$2
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./nexttrace -T -q 1  -g cn $1 | awk '
        # 基础过滤：移除纯数字+*或纯*的行
        !/^[[:space:]]*[0-9]+[[:space:]]+\*[[:space:]]*$/ &&
        !/^[[:space:]]*\*[[:space:]]*$/ &&
        # 保留条件：包含IP、AS号、主机名或延迟时间
        (/([0-9]{1,3}\.){3}[0-9]{1,3}/ || /AS[0-9]+/ || /[a-zA-Z0-9-]+\.[a-zA-Z]/ || /[0-9.]+ ms/)
    '
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"
}

test_all_tcp(){
	result_all_tcp	'ipv4.sha-4134.endpoint.nxtrace.org'	'上海电信'
	result_all_tcp	'ipv4.sha-4809.endpoint.nxtrace.org'	'上海CN2'
	result_all_tcp	'ipv4.sha-4837.endpoint.nxtrace.org'   	'上海联通'
     	result_all_tcp	'ipv4.sha-9929.endpoint.nxtrace.org'   	'上海联通9929'
	result_all_tcp	'ipv4.sha-9808.endpoint.nxtrace.org'	'上海移动'
	result_all_tcp	'ipv4.can-9808.endpoint.nxtrace.org'	'广州移动'
	result_all_tcp	'ipv4.hgh-4538.endpoint.nxtrace.org'	'杭州教育网'

	echo -e "${Info} 四网路由快速测试 已完成 ！"
}

test_single(){
	echo -e "${Info} 请输入你要测试的目标 ip :"
	read -p "输入 ip 地址:" ip

	while [[ -z "${ip}" ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "输入 ip 地址:" ip
		done

	./nexttrace -q 1 -g cn ${ip} | awk '
        # 基础过滤：移除纯数字+*或纯*的行
        !/^[[:space:]]*[0-9]+[[:space:]]+\*[[:space:]]*$/ &&
        !/^[[:space:]]*\*[[:space:]]*$/ &&
        # 保留条件：包含IP、AS号、主机名或延迟时间
        (/([0-9]{1,3}\.){3}[0-9]{1,3}/ || /AS[0-9]+/ || /[a-zA-Z0-9-]+\.[a-zA-Z]/ || /[0-9.]+ ms/)
    '

	repeat_test_single
}
repeat_test_single(){
	echo -e "${Info} 是否继续测试其他目标 ip ?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_single
	while [[ ! "${whether_repeat_single}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_single
		done
	[[ "${whether_repeat_single}" == "1" ]] && test_single
	[[ "${whether_repeat_single}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}



test_alternative(){
	select_alternative
	set_alternative
	result_alternative
}
select_alternative(){
	echo -e "${Info} 选择需要测速的目标网络: \n1.中国电信\n2.中国联通\n3.中国移动\n4.教育网"
	read -p "输入数字以选择:" ISP

	while [[ ! "${ISP}" =~ ^[1-4]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" ISP
		done
}
set_alternative(){
	[[ "${ISP}" == "1" ]] && node_1
	[[ "${ISP}" == "2" ]] && node_2
	[[ "${ISP}" == "3" ]] && node_3
	[[ "${ISP}" == "4" ]] && node_4
}
node_1(){
	echo -e "1.上海电信\n2.上海CN2\n3.厦门CN2\n4.杭州电信\n5.嘉兴电信\n6.广州电信\n7.北京电信" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海电信"		&& ip=ipv4.sha-4134.endpoint.nxtrace.org
	[[ "${node}" == "2" ]] && ISP_name="上海CN2"		&& ip=ipv4.sha-4809.endpoint.nxtrace.org
	[[ "${node}" == "3" ]] && ISP_name="厦门CN2"		&& ip=117.28.254.129
	[[ "${node}" == "4" ]] && ISP_name="杭州电信"		&& ip=ipv4.hgh-4134.endpoint.nxtrace.org
	[[ "${node}" == "5" ]] && ISP_name="嘉兴电信"		&& ip=183.134.62.129
	[[ "${node}" == "6" ]] && ISP_name="广州电信"		&& ip=ipv4.can-4134.endpoint.nxtrace.org
	[[ "${node}" == "7" ]] && ISP_name="北京电信"		&& ip=ipv4.pek-4134.endpoint.nxtrace.org
}
node_2(){
	echo -e "1.深圳联通\n2.北京联通\n3.杭州联通\n4.安徽合肥联通\n5.嘉兴联通\n6.上海联通\n7.上海联通9929" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="广州联通" 		&& ip=ipv4.can-4837.endpoint.nxtrace.org
	[[ "${node}" == "2" ]] && ISP_name="北京联通"		&& ip=ipv4.pek-4837.endpoint.nxtrace.org
	[[ "${node}" == "3" ]] && ISP_name="杭州联通" 		&& ip=ipv4.hgh-4837.endpoint.nxtrace.org
	[[ "${node}" == "4" ]] && ISP_name="安徽合肥联通" 	&& ip=112.122.10.26
	[[ "${node}" == "5" ]] && ISP_name="嘉兴联通" 		&& ip=60.12.95.255
	[[ "${node}" == "6" ]] && ISP_name="上海联通" 		&& ip=ipv4.sha-4837.endpoint.nxtrace.org
	[[ "${node}" == "7" ]] && ISP_name="上海联通9929" 	&& ip=ipv4.sha-9929.endpoint.nxtrace.org
}
node_3(){
	echo -e "1.上海移动\n2.广州移动\n3.北京移动\n4.广移V6\n5.杭州移动" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-5]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="上海移动" && ip=ipv4.sha-9808.endpoint.nxtrace.org
	[[ "${node}" == "2" ]] && ISP_name="广州移动" && ip=ipv4.can-9808.endpoint.nxtrace.org
	[[ "${node}" == "3" ]] && ISP_name="北京移动" && ip=ipv4.pek-9808.endpoint.nxtrace.org
	[[ "${node}" == "4" ]] && ISP_name="广移V6" && ip=ipv6.can-9808.endpoint.nxtrace.org
	[[ "${node}" == "5" ]] && ISP_name="杭州移动" && ip=ipv4.hgh-9808.endpoint.nxtrace.org
}
node_4(){
	ISP_name="北京教育网" && ip=101.4.117.213
}
result_alternative(){
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./nexttrace -q 1  -g cn ${ip} | awk '
        # 基础过滤：移除纯数字+*或纯*的行
        !/^[[:space:]]*[0-9]+[[:space:]]+\*[[:space:]]*$/ &&
        !/^[[:space:]]*\*[[:space:]]*$/ &&
        # 保留条件：包含IP、AS号、主机名或延迟时间
        (/([0-9]{1,3}\.){3}[0-9]{1,3}/ || /AS[0-9]+/ || /[a-zA-Z0-9-]+\.[a-zA-Z]/ || /[0-9.]+ ms/)
    '
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"

	repeat_test_alternative
}
repeat_test_alternative(){
	echo -e "${Info} 是否继续测试其他节点?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_alternative
	while [[ ! "${whether_repeat_alternative}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_alternative
		done
	[[ "${whether_repeat_alternative}" == "1" ]] && test_alternative
	[[ "${whether_repeat_alternative}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}



test_all(){
	result_all	'ipv4.sha-4134.endpoint.nxtrace.org'		'上海电信'
	result_all	'ipv4.sha-4809.endpoint.nxtrace.org'	     	'上海CN2'
	result_all	'ipv4.sha-4837.endpoint.nxtrace.org' 	  	'上海联通'
	result_all	'ipv4.sha-9929.endpoint.nxtrace.org'  	 	'上海联通9929'
	result_all	'ipv4.sha-9808.endpoint.nxtrace.org'		'上海移动'
 	result_all	'ipv4.can-9808.endpoint.nxtrace.org'		'广州移动'
	result_all	'ipv4.hgh-4538.endpoint.nxtrace.org'    	'杭州教育网'

	echo -e "${Info} 四网路由快速测试 已完成 ！"
}
result_all(){
	ISP_name=$2
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./nexttrace -q 1 -g cn $1 | awk '
        # 基础过滤：移除纯数字+*或纯*的行
        !/^[[:space:]]*[0-9]+[[:space:]]+\*[[:space:]]*$/ &&
        !/^[[:space:]]*\*[[:space:]]*$/ &&
        # 保留条件：包含IP、AS号、主机名或延迟时间
        (/([0-9]{1,3}\.){3}[0-9]{1,3}/ || /AS[0-9]+/ || /[a-zA-Z0-9-]+\.[a-zA-Z]/ || /[0-9.]+ ms/)
    '
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"
}

test_all(){
	result_all	'ipv4.sha-4134.endpoint.nxtrace.org'		'上海电信'
	result_all	'ipv4.sha-4809.endpoint.nxtrace.org'	     	'上海CN2'
	result_all	'ipv4.sha-4837.endpoint.nxtrace.org' 	  	'上海联通'
	result_all	'ipv4.sha-9929.endpoint.nxtrace.org'  	 	'上海联通9929'
	result_all	'ipv4.sha-9808.endpoint.nxtrace.org'		'上海移动'
 	result_all	'ipv4.can-9808.endpoint.nxtrace.org'		'广州移动'
	result_all	'ipv4.hgh-4538.endpoint.nxtrace.org'    	'杭州教育网'

	echo -e "${Info} 四网路由快速测试 已完成 ！"
}

test_allv6(){
	result_all	'ipv6.sha-4134.endpoint.nxtrace.org'	'上海电信'
#	result_all	'58.32.0.1'	     '上海CN2'
	result_all	'ipv6.sha-4837.endpoint.nxtrace.org'   	'上海联通'
 	result_all	'ipv6.sha-9929.endpoint.nxtrace.org'   	'上海9929'
	result_all	'ipv6.sha-9808.endpoint.nxtrace.org'	'上海移动'
 	result_all	'ipv6.can-9808.endpoint.nxtrace.org'	'广州移动'
	result_all	'2001:da8:8000:12d::2'	'教育网'

	echo -e "${Info} 路由快速测试 已完成 ！"
}

#check_system
check_root
directory
install
cd /usr/local/bin

echo -e "${Info} 选择你要使用的功能: "
echo "--------------------------------"
echo -e "1.选择一个运营商进行测试(tcp)\n2.四网路由快速测试(tcp)\n3.手动输入ip进行测试(tcp)\n4.选择一个运营商进行测试(icmp)\n5.四网路由快速测试(icmp)\n6.手动输入ip进行测试(icmp)\n7.四网IPV6路由测试(icmp):"
echo "--------------------------------"
echo -e "广告位:"
echo -e "垃圾场加速器:"
echo -e "https://lajic.eu/index.php#/register?code=OAM8uBQl"
echo "--------------------------------"
read -p "输入数字以选择:" function

	while [[ ! "${function}" =~ ^[1-7]$ ]]
		do
			echo -e "${Error} 缺少或无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" function
		done

	if [[ "${function}" == "1" ]]; then
		test_alternative_tcp
	elif [[ "${function}" == "2" ]]; then
		test_all_tcp
	elif [[ "${function}" == "3" ]]; then
		test_single_tcp
	elif [[ "${function}" == "4" ]]; then
		test_alternative
	elif [[ "${function}" == "5" ]]; then
		test_all
	elif [[ "${function}" == "6" ]]; then
		test_single
	elif [[ "${function}" == "7" ]]; then
		test_allv6
	fi
