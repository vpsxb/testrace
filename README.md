此脚本为测试vps回程一键脚本
---------------
**概述**

此脚本源自南琴浪大佬，大佬的脚本已经4年未做修改，近期（2021年3月15日），脚本核心besttrace即将过期，小弟不才，就此更新besttrace核心并且更新了部分失效的节点
~~此版本测试icmp回程，对于部分icmp回程与tcp回程不一致的鸡贼商家，可使用tcp回程版本~~

**更新**
 - 统合tcp和icmp回程，并增加ipv6回程测试
 - 升级besttrace核心版本，避免3月15日的失效提醒
 - 加入新的测试节点
 - 更新besttrace到最新1.3.2
 - 修改部分失效节点
 
 **一键脚本**
    #运行脚本
    wget https://raw.githubusercontent.com/vpsxb/testrace/main/testrace.sh -O testrace.sh && bash testrace.sh
    #后续运行脚本（再次检查也仅需运行下面代码）
    bash testrace.sh
    
**功能说明**

脚本的安装目录位于 /home/testrace
测试完成并退出脚本后，会生成测试的记录文件于 /home/testrace/testrace.log
运行脚本后将出现七个个选项，分别为

- 1.选择一个运营商进行测试(tcp)
- 2.四网路由快速测试(tcp)
- 3.手动输入ip进行测试(tcp)
- 4.选择一个运营商进行测试(icmp)
- 5.四网路由快速测试(icmp)
- 6.手动输入ip进行测试(icmp)
- 7.四网IPV6路由测试(icmp)

输入数字选择需要进行的测试。

其中手动输入的意思为指定IP测试，获取自己ip可前往https://www.ipip.net/


----------


脚本修改自 

南琴浪 https://github.com/nanqinlang-script/testrace

jcnf那坨 https://github.com/Netflixxp/jcnfbesttrace
