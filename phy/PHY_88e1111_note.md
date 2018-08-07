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

....................................
#### interfaces
XTAL1 = external reference clock

COMA pin: disables all active circuitry to draw absolute minimum power, the COMA power mode can be activated by asserting high on the COMA pin. 

> in coma mode, the PHY cannot wake up on its own by detecting activity on the CAT 5 cable.

* HSDAC+-: test pins. these pins should be left floating but brought out for probing.

AVDD: analog power 2.5v
DVDD: digital power 1.0 or 1.2v

VDDOH: 2.5v power supply for LED and CONFIG pins
VDDOX: 2.5v for MDC/MDIO INTn,125CLK, RESETn,JTAG pin
VDDO: 2.5v for MAC interface

VSS: global ground
VSSC: ground reference for XTAL1 and XTAL2.connected to the ground

NC: no connect

the mapping value of led_out and config pins are shown below:pin
![config connection](pin_connection.png)

the config pins configuration bit mapping are shown below:
![config bit mapping](config_bit_mapping.png)

some typical config pins:

* ANEG[3:0] auto-negociation configuration for copper modes
* ANEG[3:2] for fiber modes

* ENA_XC enable MDI crossover function. 
**if the MDI crossover function is diabled, then the device assumes the MDI configuration.**

* HWCFG MODE[3:0]

* DIS_FC disable fiber/copper interface auto selection

* DIS_SLEEP energy detect

INT_POL : interrupt polarity(active HIGH or LOW)

#### seperator
EMI: electro magnetic interference
包括传导，辐射，谐波，闪烁

EMC: electro magnetic compatibility

EMS: ~ sensibility

EMC 包括EMS（对外界）和EMI（自身造成）

### multi-mode DAC
very low parasitic loading xapacitances to improve the return loss requarement, which allows the use of low cost transformers.

> slew rate control and partial response(waveshaping)

* slew rate 就是电压转换速率（Slew Rate），简写为SR，简称压摆率。其定义是在1微秒或者1纳秒等时间里电压升高的幅度


## 线路编码（line coding）
线路编码又称信道编码。其作用是消除或减少数字点信号中的直流和低频分量。

>线路编码大体上分为三类：扰码二进制， 字变换码， 插入型码

**以上问题太过复杂。参看通信原理相关专业教材（后补）**

SNR or S/N signal noise ratio 信噪比

* 88e PHY device employs a on-chip hybrid to substantially reduce the near-end echo, which is the super -imposed transmit signal on the receive signal.

## echo canceller
residual echo not removed by the hybrid due to patch cord impedance mismatch, patch panel discontinuity and variations in cable impedance along the twisted pair cable.

## NEXT canceller
the device employs 3 parallel NEXT cancellers on each receive channel to cancel any high frequency cross talk.

## baseline wander(基线漂移) canceller
also known as DC shift

## digital adaptive equalizer(均衡器)
The digital adaptive equalizer removes inter-symbol interference at the receiver. The digital adaptive equalizer takes unequalized signals from ADC output and uses a combination of feedforward equalizer(FFE) and decision feedback equalizer（DFE） for the best-optimized signal-to-noise ratio.

## digital PLL

## link monitor
responsible for determining if link is established with a link partner.

## management interface (重点)
management interface includes MDC and MDIO

**CONFIG中的address[4:0]地址是为了MDIO中用的！！！**

typical w/r operations are belowing:
![w/r](write_and_read_of_mdio.png)

at high MDIO fanouts the maximum rate may be decreased depending on the output loading.

## MDC/MDIO protocol

88ee1111 器件中，hardware configuration 就是将CONFIGs 和 LED 等一些I/O口连接起来；而software configuration就是通过MDIO，MDC来对reg 进行设置！！很明显，后者的功能要多很多，而且还有一个称之为 MDC/MDIO protocol的标准协议。

## two-wire serial interface
TWSI 相当于是提供了一个bus，可以多个88e作为slave 连接。然后共享一个master，可用于MDIO，MDC 共享。。。
此时：
MDI -> SDA(serial data line)
MDC -> SCL(serial clock line)

## auto-negotiation

## downshift feature
downshift 是说，在auto-negotiation 的时候，如果是PHY device 请求 1000 Mbp的话，会一直请求，不会降档（downshift），但是有的lagacy link只有12，36线可用，而downshift feature 会自动匹配。

## loopback Modes

* loopback 有三种：MAC interface loopback and line loopback， external 1000 Mbps loopback


The MAC interface loopback mode used to test the functionality, timing, and signal intergrity of the MAC interface.

when using MAC interface loopback with copper media, the receiver will be powered down

### Virtual Cable Tester(VCT) feature

#### TDR time domain reflectometry时域反射计
TDR 通常用来测量传输线特征阻抗的仪器，它利用时域反射的原理进行特征阻抗的测量

包括：
* 快沿信号发生器
* 采样示波器
* 探头系统
快沿信号遇到阻抗就会反射，由于反射和注入信号有时间差，所以采集到的叠加信号的边缘时带台阶的。

### MDI/MDIX crossover
crossover 的意思就是UTP 线有两种，一种是同型号连接线，一种是异型号连接线，而crossover 功能可以内部交叉，而不用换线了。

The 88e device makes the necessary adjustment prior ro commencing auto-negociation.

### polarity correction
correct polariry errors on the receive pairs in 1000BASE-T and 10BASE-T.in 100BASE-T mode, the polarity dose not matter.

### Data Terminal Equipment(DTE) Detect
The  DTE power function is used to detect if a link partner requires power supplied by the device.

first, monitoring the link partner, if there is no activity coming frome the link partner, DTE power engages, and special pulses are sent to detect if the link partner requires DTE power, if the link partner has a **low pass filter** installed ,the link partner will be detected as requiring DTE power.


### Automatic and Manual Impedance Calibration
#### 1, MAC interface calibration circuit
32ohm automaticly,
22 to 55 ohm NMOS and PMOS output transistors could be controlled be writing registers.

### Packet Generator
重点研究！！！

### CRC error counter and frame counter
本来CRC conter 和frame counter是MAC function。these functions are enabled through register writes and each counter is stored in eight register bit.

enabling/ diabling/ clearing/ reading!!!

### LED interface
The LED interface consists of 6 pins:
LED_LINK10
LED_LINK100
LED_LINK1000

LED_DUPLEX
LED_RX
LED_TX
也就是led灯可以正常显示PHY的功能state，也可以认为的定制，与state无关。

reg25

LEDs can be used in single LED mode or bi-color LED mode.
LED outputs are low active.

**There are four modes of link LED operation when the LEDs are controlled by the state of the PHY**
register 24.5:3 = 000(direct LED mode)
register 24.5:3 = 001, 010, 001, 100, 111(combined LED modes. 3 types)

#### led pulse stretching and blink rate
Some of the statuses can be pulse-stretched, Pulse stretching is necessary, because the duration of these status events may be too short to be observable on the LEDs. The pulse-stretch duration can ve programmed via register 24.14:12.

Pulse stretching only applies to Duplex pin in Collision mode, or LED_RX and LED_TX pins.

### IEEE 1149.1 controller
also known as JTAG or boundary-scan, this Standard provides a solution for testing assembled printed circuit boards and other porducts based on highly complex digital integrated circuits and high-density surface-mounting assembly techniques.

**具体在进行编写测试代码的时候，function description and registor description还会详细的看！！！**

# SECTION 4: ELECTRICAL SPECIFICATIONS
### absolute maximum ratings.
### recommended operating conditions
### thermal conditions


## Section 6: order information
#### ordering part numbers and package markings



