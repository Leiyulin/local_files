	生成(generate)语句可以 *动态生成* verilog代码，当对矢量中的多个位进行重复操作时，或者当进行多个模块的实例引用的重复操作时，或者根据参数的定义来确定程序中是否应该包含某段Verilog代码的时候，使用生成语句能大大简化程序的编写过程。

#### 总结：
适用范围：
1. 矢量多位操作
2. 多模块实例引用
3. 参数自动决定是否包含目标代码

     	生成语句生成的实例范围，关键字 *generate-endgenerate* 用来指定该范围。

生成实例可以是以下的一个或多个类型：
       （1）模块；（2）用户定义原语；（3）门级语句；（4）连续赋值语句；（5）initial和always块。

generate语句有：
1. generate-for
2. generate-if
3. generate-case

generate-for语句
（1) 必须有genvar关键字定义for语句的变量。
（2）for语句的内容必须加begin和end（即使就一句）。
（3）for语句必须有个名字。
例1：assign语句实现
module test(bin,gray);
       parameter SIZE=8;
       output [SIZE-1:0] bin;
       input [SIZE-1:0] gray;
       genvar i; //genvar i;也可以定义到generate语句里面
       generate
              for(i=0;i<SIZE;i=i+1)
              begin:bit
                     assign bin[i]=^gray[SIZE-1:i];
              end
       endgenerate
endmodule

等同于下面语句
assign bin[0]=^gray[SIZE-1:0];
assign bin[1]=^gray[SIZE-1:1];
assign bin[2]=^gray[SIZE-1:2];
assign bin[3]=^gray[SIZE-1:3];
assign bin[4]=^gray[SIZE-1:4];
assign bin[5]=^gray[SIZE-1:5];
assign bin[6]=^gray[SIZE-1:6];
assign bin[7]=^gray[SIZE-1:7];
例2:
generate
       genvar i;
       for(i=0;i<SIZE;i=i+1)
       begin:shifter
              always@(posedge clk)
                     shifter[i]<=(i==0)?din:shifter[i-1];
       end
endgenerate

相当于
always@(posedge clk)
       shifter[0]<=din;
always@(posedge clk)
       shifter[1]<=shifter[0];
always@(posedge clk)
       shifter[2]<=shifter[1];
.................
       ......................
always@(posedge clk)
       shifter[SIZE]<=shifter[SIZE-1];
generate-if，generate-case和generate-for语句类似。
