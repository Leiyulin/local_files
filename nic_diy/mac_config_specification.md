*对于MAC IP 的configure 必须要深入了解config reg的机制和规定，是适用IP 的一个难点需要重点掌握*

### 以下是根据 *Intel Triple-Speed Ethernet IP core User Guide* 的概要/笔记：

#### register initialization
• External PHY Initialization using MDIO (Optional)
• PCS Configuration Register Initialization //not applay in our design
• MAC Configuration Register Initialization
## .........................how to config PHY register through MDIO 1/2 space
##### case(INTERFACE_TYPE)
	riple-Speed Ethernet System with MII/GMII or RGMII:
1. External PHY Register will Map to MDIO Space 0
Read/write to MDIO space 0 (dword offset 0x80 - 0x9F) = Read/write to PHY
Register 0 to 31

## .........................how to config MAC IP itself
//以下是进行 *register initialization* 的步骤，还有很多详细的配置的参数需要参考表格，此步骤来源 user guide

MAC Configuration Register Initialization
a.
Disable MAC Transmit and Receive DatapathDisable the MAC transmit and
receive datapath before performing any changes to configuration.
//Set TX_ENA and RX_ENA bit to 0 in Command Config Register
Command_config Register = 0x00802220
//Read the TX_ENA and RX_ENA bit is set 0 to ensure TX and RX path is
disable
Wait Command_config Register = 0x00802220
#### settings before configuration, 为了确保ENA 信号确实为0，应该读取这两位！
b.
MAC FIFO Configuration
#### 目前还不了解MAC IP 的 FIFO 的机制。
Tx_section_empty = Max FIFO size - 16
Tx_almost_full = 3
Tx_almost_empty = 8
Rx_section_empty = Max FIFO size - 16
Rx_almost_full = 8
Rx_almost_empty = 8
//Cut Throught Mode, 
#### Set this Threshold to 0 to enable Store and Forward Mode
Tx_section_full = 16
//Cut Throught Mode, Set this Threshold to 0 to enable Store and Forward
Mode
Rx_section_full = 16

c.
MAC Address Configuration
//MAC address is 00-1C-23-17-4A-CB
mac_0 = 0x17231C00
mac_1 = 0x0000CB4A
#### MAC 地址系认为定义

d.
MAC Function Configuration
//Maximum Frame Length is 1518 bytes
Frm_length = 1518
//Minimum Inter Packet Gap is 12 bytes
Tx_ipg_length = 12
//Maximum *Pause Quanta Value* for Flow Control
Pause_quant = 0xFFFF
//Set the MAC with the following option:
// 100Mbps, User can get this information from the PHY status/PCS status
//Full Duplex, User can get this information from the PHY status/PCS status
//Padding Removal on Receive
//CRC Removal
//TX MAC Address Insertion on Transmit Packet
//Select mac_0 and mac_1 as the source MAC Address
Command_config Register = 0x00800220

e.
Reset MAC
Intel recommends that you perform a *software reset* when there is a change in
the MAC speed or duplex. The MAC software reset bit self-clears when the
software reset is complete.
//Set SW_RESET bit to 1
Command_config Register = 0x00802220
Wait Command_config Register = 0x00800220

f.
Enable MAC Transmit and Receive Datapath
//Set TX_ENA and RX_ENA to 1 in Command Config Register
Command_config Register = 0x00800223
//Read the TX_ENA and RX_ENA bit is set 1 to ensure TX and RX path is
enable
Wait Command_config Register = 0x00800223


