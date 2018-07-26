## 算术操作指令的实现（共21）
**只有special 的指令EXE_* 才和EXE_*_OP仅仅高位添加两个零，其他的指令，如special2和I type指令中，两者毫无关系**
1. 简单算术操作指令（共15
**只需要一个时钟周期**
>实现只需要修改id 和 ex模块即可

* add
* addu
**有符号和无符号的区别在于，有符号运算会检查溢出，并产生溢出异常，异常结果以不会保存。而无符号则不会。**
* sub
* subu
* slt
* sltu
>比较，slt，rd,rs,rt.如果rs<rt -> rd = 1 or rd =0
*说明：*
>都是special指令，R类型指令
>10~6bit = 00000

* addi
* addiu
* slti
* sltiu
>都是I类型指令。立即数需要扩展。
>这一类型的指令中，*都是* 进行有符号扩展，且有溢出检测功能。无符号指令，没有溢出检测功能。

* clo：count 0 until 1 first appear, if only 0bit in rs value, return 32 to rd
* clz：count 1 until 0 first appear, if only 1bit in rs value, return 32 to rd
>都是R类型指令。指令码都是011100，special2

* multu(SPECIAL TYPE)：
{hi,LO} = rsXrt

* mult(SPECIAL TYPE)
有符号

* mul(SPECIAL2 TYPE):
>rsXrt有符号数相乘,结果的低32位保存在rd

2. 乘累加，乘累减指令（共4
**HI LO特殊寄存器的作用**
>hi,lo寄存器用于保存乘法，除法的结果。当用于保存乘法结果时，hi寄存器保存的高32位，lo保存的低32位；当用于保存除法的结果时，hi寄存器保存余数，lo保存商。
**需要两个时钟周期**
* 乘累加（madd
* 无符号乘累加（maddu
* 乘累减（msub
* 无符号乘累减（msubu
先乘除后与hi，lo加减

所以实现起来时需要单独一个处理线路的！！！（本例使流水线暂停

3. 除法指令（共2
* 有符号除法（div
* 无符号乘法（divu
32位至少需要32个时钟周期

