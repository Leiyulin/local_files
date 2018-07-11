
module mac_config_sub
     (
     //***********************************************************
     //--Clock And Reset Signals
     //***********************************************************
     input                               clk                     ,   
     input                               rst_n                   ,   
     //***********************************************************
     //--MAC Control Interface Signals 
     //***********************************************************
     output                              config_clk              ,//config_clk = clk, like bypass
     
     output       [7:0]                  address                 ,  
     
     output    reg                       write                   , //enable    
     output    reg[31:0]                 writedata               ,  

     output    reg                       read                    , //enable

     input        [31:0]                 readdata                ,   
     input                               waitrequest             ,

     //this is for what?
     input        [47:0]                 mac_addr                    

     );
     
     
     
reg[30:0]rst_n_cnt;
// set rst_n_cnt, cnt++ while change of clk or rst_n
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      rst_n_cnt <= 31'b0;
   else if(rst_n_cnt==31'h7fffffff)
      rst_n_cnt <= 31'h7fffffff;                      //???
   else 
      rst_n_cnt <= rst_n_cnt + 1'b1;
end

reg start_cfg;
//after "fff0" arrival time, start_cfg is always 1'b1
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      start_cfg <= 1'b0;
   else if(rst_n_cnt>=31'hfff0)
      start_cfg <= 1'b1;
   else
      start_cfg <= 1'b0;
end
     
     
reg    [7 : 0]     cfg_cs;
reg    [7 : 0]     cfg_ns; 
reg    [7 : 0]     rdaddr;
reg    [7 : 0]     wraddr;


//-------------------------------------------
//command config register dword offset 0x02
parameter        TX_ENA    = 1'b1        ; //Transmit enable. enable the transmit datapath
parameter        RX_ENA    = 1'b1        ; //Receive enable . enable the receive datapath
parameter        XON_GEN   = 1'b0        ; //pause frame generation with a pause quanta of 0
parameter        ETH_SPEED = 1'b1        ; //1000m, prior to set_1000 signal
parameter        PROMIS_EN = 1'b0        ; //promiscuous enable!!!!useful
//Promiscuous enable. Set this bit to 1 to enable promiscuous mode. 
//In this mode, the MAC function receives all frames without address filtering.
parameter        PAD_EN    = 1'b1        ;
// Padding removal on receive. Set this bit to 1 to remove padding from receive frames
// before the MAC function forwards the frames to the user application. This bit has no effect
// on transmit frames.This bit is not available in the small MAC variation.
parameter        CRC_FWD   = 1'b0        ;//CRC forwarding on receive. 
//Set this bit to 1 to forward the CRC field to the user application. 
//Set this bit to 0 to remove the CRC field from receive frames 
//before the MAC function forwards the frame to the user application.
//The MAC function ignores this bit when it receives a padded frame and
//the PAD_EN bit is 1. In this case, the MAC function checks the CRC 
//field and removes the checksum and padding from the frame before 
//forwarding the frame to the user application.
parameter        PAUSE_FWD = 1'b1 ;          
//Pause frame forwarding on receive. 
//Set this bit to 1 to forward receive pause frames to the user application. 
//Set this bit to 0 to terminate and discard receive pause frames.
parameter       PAUSE_IGNORE = 1'b0;
parameter       TX_ADDR_INS  = 1'b0;
//MAC address on transmit. 
//Set this bit to 1 to overwrite the source MAC address in transmit frames 
//received from the user application with the MAC primary or 
//supplementary address configured in the registers. The 
//TX_ADDR_SEL bit determines the address selection.
//Set this bit to 0 to retain the source MAC address in transmit frames 
//received from the user application.
parameter       HD_ENA      =  1'b1;
//Half-duplex enable. 
//Set this bit to 1 to enable half-duplex.
//Set this bit to 0 to enable full-duplex. 
//The MAC function ignores this bit if you set the ETH_SPEED bit to 1.

//parameter       EXCESS_COL    readonly,excessive collosion condition
//The MAC function sets this bit to 1 when it discards a frame after
//detecting a collision on 16 consecutive frame retransmissions

//parameter       LATE_COL      readonly,late collision condition
//The MAC function sets this bit to 1 when it detects a collision after
//transmitting 64 bytes and discards the frame.

parameter             SW_RESET             = 1'b0;
//software reset enable

parameter             MHASH_SEL            = 1'b0;
//Hash-code mode selection for multicast address resolution.
//• Set this bit to 0 to generate the hash code from the full 48-bit
//destination address.


parameter             LOOP_ENA             = 1'b1;
//local loopback enable

parameter [2 : 0]     TX_ADDR_SEL          = 3'd0;
//fuction with TX_ADDR_INS
//select diffrent overwrite address

parameter             MAGIC_ENA            = 1'b0;
//magic packet detection disable

parameter             SLEEP                = 1'b0;
//function with MAGIC_ENA

//parameter           WAKEUP readonly 

parameter             XOFF_GEN             = 1'b0;
//Pause frame generation. Set this bit to 1 to generate a pause frame
//independent of the status of the receive FIFO buffer

parameter             CNTL_FRM_ENA         = 1'b0;
//control frame enable on receive other than pause frame

parameter             NO_LGTH_CHECK        = 1'b0; 
//payload length check on receive

parameter             ENA_10               = 1'b0;
parameter             RX_ERR_DISC          = 1'b1;
//function with rx_section_full register to 0; store and forward operation
//discard erroneous frames received

parameter             DISABLE_READ_TIMEOUT = 1'b0;   
//copnfiguration register read timeout

parameter             CNT_RESET            = 1'b0;   
//statistics counters reset
//this line above is all of the command config (32bits)
//...................................................   

parameter             FRM_LENGTH           = 1518;
//dword offset 0x05 frm_length.bits[15:0]'
//typical value is 1518'

parameter             MAC_ADDR0            = 32'habababab;
parameter             MAC_ADDR1            = 32'h0000abab; //mac_addr = 55-44-33-22-11-00
//dword offset 0x03, 0x04, stored in reverse order

//this line above for just writedata configuration


//.........................................
//parameters below for cfg_ns setting
//a FSM state setting
parameter             CFG_WAIT_START    = 8'd1;
parameter             CFG_READ_VER      = 8'd2;
parameter             CFG_WRITE_SCRATCH = 8'd3;
parameter             CFG_READ_SCRATCH  = 8'd4;
parameter             CFG_MAC_CONFIG    = 8'd5;
parameter             CFG_MAC_ADDR0     = 8'd6;
parameter             CFG_MAC_ADDR1     = 8'd7;
parameter             CFG_WRE_IPG_LEN   = 8'd8;
parameter             CFG_WRE_FRE_LEN   = 8'd9;
parameter             CFG_WRE_QUANT     = 8'd10;
//
parameter             CFG_TX_SECTION_EMPTY=8'd11;
parameter             CFG_TX_ALMOST_FULL =8'd12;
parameter             CFG_TX_ALMOST_EMPTY=8'd13;
parameter             CFG_TX_SECTION_FULL=8'd14;
//
parameter             CFG_SGMII_IF_MODE = 8'd15;//ADD 2014 3 10
parameter             CFG_SGMII_CTRL_REG= 8'd16;
parameter             CFG_DONE          = 8'd17; 

//initiate cfg_cs
always @ (posedge clk or negedge rst_n) begin 
  if (!rst_n)
   cfg_cs <= CFG_WAIT_START;
  else 
   cfg_cs <= cfg_ns ;
end 

//cfg_cs -> cfg_ns notice these assignment perform a FSM with above statement   
//waitrequest: reg_busy
// Register interface busy. Asserted during register read or register
// write access; deasserted when the current register access
// completes.                            
always @ (*) begin 
   case(cfg_cs) 
     CFG_WAIT_START    : cfg_ns = (start_cfg&waitrequest) ? CFG_READ_VER      : CFG_WAIT_START   ;
     CFG_READ_VER      : cfg_ns = (!waitrequest)          ? CFG_WRITE_SCRATCH : CFG_READ_VER     ;
     CFG_WRITE_SCRATCH : cfg_ns = (!waitrequest)          ? CFG_READ_SCRATCH  : CFG_WRITE_SCRATCH;
     CFG_READ_SCRATCH  : cfg_ns = (!waitrequest)          ? CFG_MAC_CONFIG    : CFG_READ_SCRATCH ;
     CFG_MAC_CONFIG    : cfg_ns = (!waitrequest)          ? CFG_MAC_ADDR0     : CFG_MAC_CONFIG ;
     CFG_MAC_ADDR0     : cfg_ns = (!waitrequest)          ? CFG_MAC_ADDR1     : CFG_MAC_ADDR0    ;
     CFG_MAC_ADDR1     : cfg_ns = (!waitrequest)          ? CFG_WRE_IPG_LEN   : CFG_MAC_ADDR1    ;
     CFG_WRE_IPG_LEN   : cfg_ns = (!waitrequest)          ? CFG_WRE_FRE_LEN   : CFG_WRE_IPG_LEN  ;
     CFG_WRE_FRE_LEN   : cfg_ns = (!waitrequest)          ? CFG_WRE_QUANT     : CFG_WRE_FRE_LEN  ;    
     CFG_WRE_QUANT     : cfg_ns = (!waitrequest)          ? CFG_TX_SECTION_EMPTY : CFG_WRE_QUANT    ;        
     CFG_TX_SECTION_EMPTY:cfg_ns = (!waitrequest)         ? CFG_TX_ALMOST_FULL : CFG_TX_SECTION_EMPTY    ;
     CFG_TX_ALMOST_FULL:cfg_ns = (!waitrequest)           ? CFG_TX_ALMOST_EMPTY : CFG_TX_ALMOST_FULL    ;
     CFG_TX_ALMOST_EMPTY:cfg_ns = (!waitrequest)          ? CFG_TX_SECTION_FULL : CFG_TX_ALMOST_EMPTY    ;
     CFG_TX_SECTION_FULL:cfg_ns = (!waitrequest)          ? CFG_DONE          : CFG_TX_SECTION_FULL    ;   
     CFG_SGMII_IF_MODE : cfg_ns = (!waitrequest)          ? CFG_SGMII_CTRL_REG: CFG_SGMII_IF_MODE    ;
     CFG_SGMII_CTRL_REG: cfg_ns = (!waitrequest)          ? CFG_DONE          : CFG_SGMII_CTRL_REG    ;
     CFG_DONE          : cfg_ns = cfg_cs                                                         ;
    default : cfg_ns = CFG_WAIT_START ;   
  endcase    
end  

//cfg_ns -> read(1bit)
always @ (posedge clk or negedge rst_n) begin 
  if (!rst_n)
    read <= 1'b0;
  else if ((cfg_ns == CFG_READ_VER)|(cfg_ns == CFG_READ_SCRATCH))   
    read <= 1'b1;
  else 
    read <= 1'b0;    
end 

//cfg_ns -> rdaddr(8bit)
always @ (posedge clk or negedge rst_n) begin 
  if (!rst_n)
    rdaddr <= 8'h00;
  else if (cfg_ns == CFG_READ_VER)  
    rdaddr <= 8'h00;
  else if (cfg_ns == CFG_READ_SCRATCH)   
    rdaddr <= 8'h01;
  else
    rdaddr <= rdaddr;  
end 

//cfg_ns -> writedata(32bit)
always @ (posedge clk or negedge rst_n)  begin 
  if (!rst_n)
    writedata <= 32'h0;
  else if (cfg_ns == CFG_WRITE_SCRATCH)  
    writedata <= 32'ha5a5_a5a5;
  else if (cfg_ns == CFG_MAC_CONFIG )  begin 
      //writedata = 32'h0400_803b;
    writedata [0 ] = 1'b1 ;//TX_ENA; // 1 
    writedata [1 ] = 1'b1 ;//RX_ENA; // 1
    writedata [2 ] = 1'b0 ;//XON_GEN;// 0    
    writedata [3 ] = 1'b0 ;//ETH_SPEED;//1     
    writedata [4 ] = 1'b1 ;//PROMIS_EN; //1   
    writedata [5 ] = 1'b1 ;//PAD_EN;  //1   
    writedata [6 ] = 1'b0 ;//CRC_FWD;  //0   
    writedata [7 ] = 1'b0 ;//PAUSE_FWD;//0     
    writedata [8 ] = 1'b0 ;//PAUSE_IGNORE;//0     
    writedata [9 ] = 1'b0 ;//TX_ADDR_INS; //0    
    writedata [10] = 1'b0 ;//HD_ENA;   //0  
    writedata [11] = 1'b0 ;//     //0
    writedata [12] = 1'b0 ;//     //0
    writedata [13] = 1'b0 ;//SW_RESET;  //0   
    writedata [14] = 1'b0 ;//MHASH_SEL; //0 
	 
    writedata [15] = 1'b0 ;//LOOP_ENA;  //1  
	 
    writedata [18 : 16] = 3'd0;//TX_ADDR_SEL[2:0];//000     
    writedata [19] = 1'b0;//MAGIC_ENA;   //0  
    writedata [20] = 1'b0;//SLEEP;      //0
    writedata [21] = 1'b0;//     //0 
    writedata [22] = 1'b0;//XOFF_GEN;   //0   
    writedata [23] = 1'b0;//CNTL_FRM_ENA;//0      
    writedata [24] = 1'b0;//NO_LGTH_CHECK; //0     
    writedata [25] = 1'b0;//ENA_10;    //0  
    writedata [26] = 1'b1;//RX_ERR_DISC;  //1    
    writedata [27] = 1'b0;//DISABLE_READ_TIMEOUT;//0      
    writedata [30 : 28] = 3'd0;    //0  
    writedata [31] = 1'b0; //CNT_RESET;    //0
    end 
  else if (cfg_ns == CFG_MAC_ADDR0  )  
    writedata <= MAC_ADDR0;    
  else if (cfg_ns == CFG_MAC_ADDR1  ) 
    writedata <= MAC_ADDR1;       
  else if (cfg_ns == CFG_WRE_IPG_LEN)  
    writedata <= 32'h0000000c;  
  else if (cfg_ns == CFG_WRE_FRE_LEN)    
    writedata <= 32'd1518; 
  else if (cfg_ns == CFG_WRE_QUANT)            
    writedata <= 32'd15;
  else if (cfg_ns == CFG_TX_SECTION_EMPTY)            
    writedata <= 32'd2048-16;
  else if (cfg_ns == CFG_TX_ALMOST_FULL)            
    writedata <= 32'd3;
  else if (cfg_ns == CFG_TX_ALMOST_EMPTY)            
    writedata <= 32'd8;
  else if (cfg_ns == CFG_TX_SECTION_FULL)            
    writedata <= 32'd16;
  else if (cfg_ns == CFG_SGMII_IF_MODE) 
     writedata <=32'h0003;
  else if (cfg_ns == CFG_SGMII_CTRL_REG) 
     writedata <=32'h1140;
  else
    writedata <= writedata;  
end 

// cfg_ns -> wraddr(8bit)
//wraddr is 32bit word aligned adress
always @ (posedge clk or negedge rst_n)  begin 
  if (!rst_n)
    wraddr <= 8'h0;
  else if (cfg_ns == CFG_WRITE_SCRATCH)  
    wraddr <= 8'h01;
  else if (cfg_ns == CFG_MAC_CONFIG )   
    wraddr <= 8'h02;
  else if (cfg_ns == CFG_MAC_ADDR0  )  
    wraddr <= 8'h03;     
  else if (cfg_ns == CFG_MAC_ADDR1  ) 
    wraddr <= 8'h04;     
  else if (cfg_ns == CFG_WRE_IPG_LEN)  
     wraddr <= 8'h17;  
  else if (cfg_ns == CFG_WRE_FRE_LEN)    
     wraddr <= 8'h05; 
  else if (cfg_ns == CFG_WRE_QUANT)            
     wraddr <= 8'h06;
  else if (cfg_ns == CFG_TX_SECTION_EMPTY)            
     wraddr <= 8'h09;
  else if (cfg_ns == CFG_TX_ALMOST_FULL)            
     wraddr <= 8'h0E;
  else if (cfg_ns == CFG_TX_ALMOST_EMPTY)            
     wraddr <= 8'h0D;
  else if (cfg_ns == CFG_TX_SECTION_FULL)            
     wraddr <= 8'h0A;
  else if (cfg_ns == CFG_SGMII_IF_MODE) 
     wraddr <= 8'h94;
  else if (cfg_ns == CFG_SGMII_CTRL_REG) 
     wraddr <= 8'h80;
  else
     wraddr <= wraddr;  
end 

// cfg_ns -> write(1bit)
always @ (posedge clk or negedge rst_n)  begin 
  if (!rst_n)
    write <= 1'b0;
  else if (cfg_ns == CFG_WRITE_SCRATCH)  
    write <= 1'b1;
  else if (cfg_ns == CFG_MAC_CONFIG )   
    write <= 1'b1;
  else if (cfg_ns == CFG_MAC_ADDR0  )  
    write <= 1'b1; 
  else if (cfg_ns == CFG_MAC_ADDR1  ) 
     write <= 1'b1;  
  else if (cfg_ns == CFG_WRE_IPG_LEN)  
     write <= 1'b1;
  else if (cfg_ns == CFG_WRE_FRE_LEN)    
     write <= 1'b1;
  else if (cfg_ns == CFG_WRE_QUANT)            
     write <= 1'b1;
  else if (cfg_ns == CFG_TX_SECTION_EMPTY)            
     write <= 1'b1;
  else if (cfg_ns == CFG_TX_ALMOST_FULL)            
     write <= 1'b1;
  else if (cfg_ns == CFG_TX_ALMOST_EMPTY)            
     write <= 1'b1;
  else if (cfg_ns == CFG_TX_SECTION_FULL)            
     write <= 1'b1;
  else if (cfg_ns == CFG_SGMII_IF_MODE) 
     write <= 1'b1;
  else if (cfg_ns == CFG_SGMII_CTRL_REG) 
     write <= 1'b1;
  else
     write <= 1'b0;
end 

assign address = (write) ? wraddr : rdaddr;

reg [7 : 0] cnt_done;
//one rst option lead one cfg cycling
//cnt_done is a delay after config done
always @ (posedge  clk or negedge rst_n) begin 
  if (!rst_n)
    cnt_done <= 8'd0;
  else if (cfg_cs == CFG_DONE) begin 
    if (cnt_done == 255)
	   cnt_done <= 255;
	 else 
	   cnt_done <= cnt_done + 1'b1; 
  end   
end 

wire done_cfg = ((cfg_cs == CFG_DONE)&(cnt_done == 255)) ? 1'b1 : 1'b0;

assign config_clk = clk;

endmodule
