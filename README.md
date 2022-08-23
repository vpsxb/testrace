此脚本为测试vps回程一键脚本
---------------
**概述**

此脚本源自南琴浪大佬，大佬的脚本已经4年未做修改，近期（2021年3月15日），脚本核心besttrace即将过期，小弟不才，就此更新besttrace核心并且更新了部分失效的节点
此版本测试icmp回程，对于部分icmp回程与tcp回程不一致的鸡贼商家，可使用tcp回程版本
https://github.com/jamespan2012/jcnfbesttrace/tree/jcnfbesttracetcp

**更新**

 - 升级besttrace核心版本，避免3月15日的失效提醒
 - 加入新的测试节点
 - 更新besttrace到最新1.3.2
 - 修改部分失效节点
 
 **一键脚本**
 
    #下载使用脚本并删除老版本（icmp回程）
    rm /home/testrace/ /home/tstrace/ -rf
    wget -O jcnf.sh https://raw.githubusercontent.com/jamespan2012/jcnfbesttrace/main/jcnf.sh -O jcnf.sh && bash jcnf.sh
    #下载使用脚本并删除老版本（tcp回程）
    rm /home/testrace/ /home/tstrace/ -rf
    wget -O jcnf.sh https://raw.githubusercontent.com/jamespan2012/jcnfbesttrace/jcnfbesttracetcp/jcnf.sh -O jcnf.sh && bash jcnf.sh
    

    #后续运行脚本（再次检查也仅需运行下面代码）
    bash jcnf.sh
    
**功能说明**

脚本的安装目录位于 /home/testrace
测试完成并退出脚本后，会生成测试的记录文件于 /home/testrace/testrace.log
运行脚本后将出现三个选项，分别为

- 1.选择一个节点进行测试
- 2.四网路由快速测试
- 3.手动输入ip进行测试

输入数字选择需要进行的测试。

其中手动输入的意思为指定IP测试，获取自己ip可前往https://www.ipip.net/


----------


脚本修改自 

南琴浪 https://github.com/nanqinlang-script/testrace

jcnf那坨 https://github.com/Netflixxp/jcnfbesttrace
