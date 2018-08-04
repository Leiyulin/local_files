### switch(transistor) processing
* event-driven simulation algorithm
* switch-level modeling
*switch*:

* bi-directional signal flow and require coordinated processing of nodes connected by switches

*switch model elements in Verilog*:
>tran
>tranif0
>tranif1
>rtran
>rtranif0
>rtranif1

在switch processing 中，所有的连接的元件都必须是bidirectional,因为inputs and outputs interact

### switch processing需要模拟器的支持：
* *a simulator can do this using a relaxation technique*
* A simulator can
do this using a relaxation technique. The simulator can process tran at any time. It can process a subset of
tran-connected events at a particular time, intermingled with the execution of other active events.

### driving strength
可以定义特定scalar net types 的driving strength
![scalar net type](scalar_net.png)
如：supply1(0) strong1(0) pull1(0) weak1(0) highz1(0)

#### default strength is (strong1,strong0)

### gate and switch level modeling

**There are 14 logic gates and 12 switches predefined in the Verilog HDL to provide the gate and switch level modeling facility. Modeling with logic gates and switches has the following advantages**

bidirectional pass switches **shall not delay signals propagationg through them**

### generation
genvars are only defined during the evaluation of the generate instantiations and do not exist during simulation of a design.

>
