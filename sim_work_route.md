## 用icarus verilog + waveform 进行verilog代码仿真的流程
 *总是忘记指令和步骤，本文档罗列至此，以备后用*

### 用 <iverilog> 进行仿真 转换成vvp格式的文件
-c<file> list of source files
-o <filename> specify output filename, default name is a.out
-s <topmodule> specify the top module not!! file
-t<target> indicate a target output format

*TARGET LIST*:
* null, used for checking syntax error
* vvp, default, is a runtime program run by vvp command
* fpga, synthesis target as EDIF fromat, EDIF = electronic
  design interchange format
* VHDL, translation to VHDL from verilog

*注：其实在适用testbench仿真的时候，top文件入口应该设置成tb文件！*
标准格式： iverilog -o <file> <topfile>

### 用 <vvp> 进行仿真，出的结果是数据表格
vvp is a run time engine excutes vvp target produced by iverilog.
-l<logfile> put MCI(media control interface) output into specified
  file
*extended argumemts below should come after th design file name.*
-vcd variable change dump generated by simulation tools.
and other useful dump files, like lxt design for icarus verilog tools.

标准格式： vvp <file produced by iverilog> -vcd

*当要产生vcd的时候，必须在testbench代码中加入一段！！！！*
	initial
		begin
			$dumpfile("dump file name added here!");
			$dumpvars(0,test);
		end
$dumpvar系统任务：指定需要记录到VCD文件中的信号，可以指定某一模块层次上的所有信号，也可以单独指定某一个信号。

典型语法为$dumpvar(level, module_name); 参数level为一个整数，用于指定层次数，参数module则指定要记录的模块。整句的意思就是，对于指定的模块，包括其下各个层次(层次数由level指定)的信号，都需要记录到VCD文件中去。
### 用 <gtkwave> 查看waveform



