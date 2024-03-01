此脚本为测试vps回程一键脚本
---------------
**概述**

此脚本源自南琴浪大佬，大佬的脚本已经4年未做修改，脚本核心besttrace已于2021年3月15日过期，小弟不才，就此更新besttrace核心并且更新了部分失效的节点
~~此版本测试icmp回程，对于部分icmp回程与tcp回程不一致的鸡贼商家，可使用tcp回程版本~~

**更新**
 ~~- 统合tcp和icmp回程，并增加ipv6四网回程测试(受限于betstrace，ipv6只支持icmp回程测试)~~
 ~~- 升级besttrace核心版本，避免失效提醒~~
 ~~- 加入新的测试节点~~
 ~~- 更新besttrace到最新1.3.2~~
 - 修改部分失效节点
 - 由于besttrace的api调用限制，已将besttrace替换为优秀的开源项目[nexttrace](https://github.com/nxtrace/Ntrace-core)
 
 **运行脚本**
 
    wget https://raw.githubusercontent.com/vpsxb/testrace/main/testrace.sh -O testrace.sh && bash testrace.sh
        
**功能说明**

~~脚本的安装目录位于 /home/tstrace~~
~~测试完成并退出脚本后，会生成测试的记录文件于 /home/tstrace/testrace.log~~
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

**ARM机器运行**

得益于nexttrace优秀的兼容性，直接运行脚本即可。

~~将/home/tstrace/besttrace目录可执行文件做相应替换即可~~

~~    mv /home/tstrace/besttrace/besttracearm /home/tstrace/besttrace/besttrace ~~
   
~~其他架构机器也可做相应替换，本来脚本可以加系统架构判断，但是我懒，而且不会……~~

----------


脚本修改自 

南琴浪 https://github.com/nanqinlang-script/testrace

jcnf那坨 https://github.com/Netflixxp/jcnfbesttrace

特别鸣谢

nexttrace https://github.com/nxtrace/Ntrace-core
