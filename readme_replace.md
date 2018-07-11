### 对于流水线停滞，两种方式：
* 引入缓存，缩短直接从内存取指的时间（适用于取指时间明显长于其他阶段的情况）
* 五级流水，让停滞的时间期间也有运行阶段，相对于是 *‘填’* 的手法
### 五级流水分别是：
取指，译码，执行，访存，回写
* 访存阶段：
	* 如果是单纯的 *Load/Store* 指令，则访问存储器；否则传递到回写阶段。
	* 另一方面，如果有 *异常处理* 则会处理异常并 *jump*
* 回写阶段：回写是将结果回写到寄存器的过程，为下一次运算做准备

### debug
指令长度： 32bit
// size:
// cell size: 32bit
// number of cells: 2^17 = 64K
// total size:  64K * 32 bit

addrBus 2^32
32 -17 = 15

initial begin
	$display ("op1: %h", inst_mem[1]);
	$display ("op1: %h", inst_mem[2]);
	$display ("op1: %h", inst_mem[3]);
	$display ("op1: %h", inst_mem[4]);
end

## 如何一个输出信号接多个输入口
verilog 中端口绑定只能时一对一的，这个时候需要，assgin语句直接赋值。
而且assign的只能时net形的变量
