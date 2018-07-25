**在进行initial rom的时候需要读取一个由多行指令行（16进制32bit）组成的data文件，而由mips标准的汇编文件，转换成指令码需要一系列步骤，先列举如下：**

1. 首先要安装mips交叉编译工具链层

2. 使用as工具，
	mips64-linux-gnu-as *file name* -o *outputfile.o*

3. 使用readelf，或者objdump工具查看生成的文件
	//文件开头有magic number表示这是一个elf文件
	//7f 45 4c 46
	//readelf 相当于是看已经解码的结果，如果要看文件原来的二进制数，需要 -x选项

4. 现在生成的是一个relocatable ELF文件，要使用ld工具进行链接：
	-ld -T *scriptfile to describe the output* *inputfile.o* -o *outputfile.om*
	//其中，scriptfile需要自己编写也可以用default，本例中文件名为*.ld
	//生成的文件是excutable ELF

5. 使用objcopy 转化为binary格式：
	-objcopy -O binary *inputfile.om* *outputfile.bin*
	//使用vim查看二进制文件时，需要设置：%！xxd
	//退出二进制查看模式需要设置：%！xxd -r
	//可以看出objcopy只是输出了section.text的部分，这正是我们需要的

6. 为了仿真的需要，我们还可以进行反汇编：
	-objdump -D *.om > *.asm

*注意：以上的文件的后缀都是自己定义的！！可更改*

