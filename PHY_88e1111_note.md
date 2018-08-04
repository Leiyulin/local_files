1. IEEE defines 32 registers address space for PHY
paging mechanism used for extend registers' number

page0,register0
15-0
15. software reset 	1
14. loopback 		0
13. speed select(lsb)	
14. auto-negotiation enable	

## physical coding sublayer
PCS resides at the top of the physical layer (PHY), and provides an interface between the Physical Medium Attachment (PMA) sublayer and the Media Independent Interface (MII). It is responsible for data encoding and decoding, scrambling and descrambling, alignment marker insertion and removal, block and symbol redistribution, and lane block synchronization and deskew

## 高速数据接口形式

* ECL 和PECL（positive）
PECL 标准最早由motorola公司提出  

* CML 电路：电流模式逻辑，相比于PECL，它直接在内部集成了阻抗匹配的50 ohm电阻。所以在互连的时候可以直接相连（直流），或者耦合电容就可以了。
CML 电路比ECL 电路功耗小

* LVDS = low voltage differential signaling
信号摆幅小，所以能在低电压运行。
* IN+ IN- 输入差分阻抗为100ohm，输入级还包括一个自动电平调整电路。将共模电压调整为一个固定值。（adaptive level shifter）.其后是具有滞回特性的sxhimitt trigger,再后面才是差分放大器。

* 在光传输系统中，没有CML 和LVDS 的互连问题。因为LVDS 通常用作并联数据传输，而CML通常用作串行数据传输。

* transceiver 会由一个signal detect output 到MAC

* MAC interface在选择模式的时候主要是配置HWCFG_MODE REG

* SERDES INTERFACE ACTUALLY AND SGMII ARE TWO DIFFERENT INTERFACE！！！！

* auto-negociation advertise information is send by MAC and used by PHY to control the media!!!

#### hardware configuration
configuration options like physical address, PHY operating mode, auto-negociation, MDI crossover(ENA_XC) and physical connection type are configured by using the configuration pins,

* 需要给CONFIG[x]赋值，一个CONFIG是3bit大小

the CONFIG[6:0] inputs come out to the corresponding config pins.

1.4 pin definition
![pin definition](fig/pin_definition.png)

我们实验板所用的封装类型是117-pin TFBGA PACKAGE
thin flat ball grid array

pin脚如图：
![117 pin](fig/117_pin.png)

table 8: management interface interrupt
![mdi](fig/mdi.png)

mdc -> input only 3.3v tolerant, maxumum frequency supported is 8.3 MHz

mdio requires a pull-up resistor in a range from 1.5kohm to 10kohm

INTn -> open drain output,programble polarity

#### two-wire serial interface (twsi)
TWSI operates with a serial data line(SDA) and a serial clock line(SCL)
TWSI主要是用来替代MDI 和MDC的（media dependent），链接在PHY和media之间

#### LED_LINK 
LED_LINK, output DC sink capability, which means low pin.
LED_LINK is a multi-fuction pin used to configure the 88e1111 deveice at the de-assertion of hardware reset

注意LED——DUPLEX PORT
![led_duplex](fig/led_duplex.png)





