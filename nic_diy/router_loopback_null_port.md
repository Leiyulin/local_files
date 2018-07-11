## 虚接口
如loopback,null等，他们有以下共同点：
1. 不存在与之对应的真实的物理接口；
2. 都是手工配置，不会自动生成；
3. 接口状态永远都是up，不会down掉。
虚接口共有以下几种
1. loopback
2. null
//路由黑洞
3. tunnel
//三隧道协议，最常用功能是用来在ipv4中封装ipv6包
4. virtual-template
//将多个PPP接口逻辑捆绑在一起。
5. subinerface
6. dialer interface
7. portchannel
//逻辑上将多个相同物理端口合并为一个。
//功能：1。增加网络带宽，2.提供链路备份
8. SVI交换虚拟接口
9. bridge-group virtual interface BVI


