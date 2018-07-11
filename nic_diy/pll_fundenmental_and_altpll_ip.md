1. 锁相环电路是负反馈电路。输出跟踪输入的频率（同步）。也称为闭环同步系统。

2. 特殊的，当输入信号频率和输入信号频率相同时，信号之间的相位差同步（为常数）。所以称为所相环路。

*频率相同是目的，相位相同（锁定）是手段*

锁相环将信号之间的相位进行比较，产生*相位误差电压*，来调节输出信号的频率，最终达到 *相位锁定，信号同频*

## altpll IP core
PLL Behavior
1. PLL lock time, PLL acquisition time
2. PLL resolution, the mimumum frequency increment value of a PLL VCO
3. PLL sample rate, fREF/N

## operation modes
support 5 diffrent clock feedback modes
all modes allows function:
1. clock multiplication
2. clock division
3. phase shifting
4. duty-cycle programming, means duty changable!!
*5 feedback modes*:
* normal mode
* source synchronous mode
* zero delay buffer mode
* no compensation mode
* external feedback mode


## advanced features
*for high-end discrete PLL devices previously*
### signals using with advanced control:
1. pllena
2. areset 
3. pfdena
pllena: by default the pllena signal is tied to VCC internally

areset:when areset signal is deasserted, the Pll resynchronizes its input and tries to gain lock

pfdena: PFD circuit(phase frequency detection) enable, it's tied to VCC by default. when pfdena signal deasserted, PLL output depends on outside clock.

pllena and areset signals doesn't disable the VCO, instead reset the VCO to its nominal value. other word, the VCO always on-work as soon as you instantiate IP in your design

*advanced features*
1. clock switchover
description:switch between two input clocks
application: video application, telecommunication, storage, server market

supported modes:
* automatic switcheover: when stop toggling or loss-of-lock occurs
* manual clock switchover: using clkswitch signal override automatic mode

2. spread-Spectrum Clocking
Spread-spectrum technology reduces electromagnetic interference(EMI) in a system. this technology wrokd by distributing the clock energy over a broad frequency range.

down spread percent and modulation frequency, often called sweep rate, defines how fast the spreading signal sweeps from the minimum to the maximum frequency.

3. Gated Lock and Self-Reset
lock time 
* glitch introduced by circuit operation
* jitter introduced by source signal

Gated lock for filtering glitch and jitter

Self-Reset on Loss of Lock

4. Programmable Bandwidth
The higher the charge pump current, the higher the PLL bandwidth

5. Advanced PLL Parameters
generation files for third-party simulator

6. PLL Dynamic Reconfiguration
reconfigure enable on-the-fly using .hex or .mif memory initialization file and need ALTPLL_RECONFIG IP

7. Dynamic Phase Configurarion
adjust the output phase shift in real time. 

8. PLL Output Counter Cascading
in 28nm devices, a C-counter input can be either a VCO output or the cascaded output of a neighboring C-counter. Cascading 

### design examples
STUB SERIES TERMINATED LOGIC 短截线串联端接逻辑






