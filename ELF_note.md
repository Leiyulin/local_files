## gnu工具链：（此处对于mips指令而言）
1. as 工具将 <汇编语言文件> 转换成 <object> 文件
   .S -> .o, 其实.o文件就是一个ELF 文件
*ELF* 文件：
executable and linkable format, 是UNIX系统试验室（USL）作为应用程序二进制接口（application binary interface,ABI）开发的，由三种类型：
1. 可重定位 relocatable 文件， 和其他object文件一起创建一个可执行文件，共享文件
2. 可执行 executable 文件，保存执行程序
3. 共享目标文件
*ELF* 由4部分组成：
1. ELF header
2. program header table 
3. section
4. section header table

## 使用链接工具 <ld> 时需要一个链接描述脚本 .ld 文件

