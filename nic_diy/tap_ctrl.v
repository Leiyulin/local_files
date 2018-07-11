`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
module tap_ctrl(
      input                               clk                     ,   
      input                               rst_n                   ,   
      //--光模块1控制信号
      input                               sfp1_los                ,   
      output       reg                    sfp1_txdisable          ,   
      input                               sfp1_detect             ,   
      //--PHY1芯片的链接状态
      input                               phy1_led_link_1000      ,   //                           PHY.led_link1000
      input                               phy1_led_link_100       ,   //                           PHY.led_link100
      input                               phy1_led_link_10        ,   //                           PHY.led_link10
      input                               phy1_led_tx             ,   //                           PHY.led_tx
      input                               phy1_led_rx             ,   //                           PHY.led_rx
      input                               phy1_led_duplex         ,   //                           PHY.led_duplex
      //--
      output                              phy1_led_green          ,   
      output                              phy1_led_yellow         ,   
      //--光模块2控制信号
      input                               sfp2_los                ,   
      output       reg                    sfp2_txdisable          ,   
      input                               sfp2_detect             ,   
      //--PHY2芯片的链接状态
      input                               phy2_led_link_1000      ,   //                           PHY.led_link1000
      input                               phy2_led_link_100       ,   //                           PHY.led_link100
      input                               phy2_led_link_10        ,   //                           PHY.led_link10
      input                               phy2_led_tx             ,   //                           PHY.led_tx
      input                               phy2_led_rx             ,   //                           PHY.led_rx
      input                               phy2_led_duplex         ,   //                           PHY.led_duplex
      //--
      output                              phy2_led_green          ,   
      output                              phy2_led_yellow         ,   
      //---
      output       reg                    phy1_reset              ,   
      output       reg                    phy2_reset              ,
      //-
      output       reg                    mac1_enable             ,   
      output       reg                    mac2_enable                
    );
//----------------------------------------------------------------------------
//---RESET 88E11
//----------------------------------------------------------------------------
reg            sfp1_los_1r;
reg            sfp1_los_2r;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)begin
      sfp1_los_1r   <=   1'b1;
      sfp1_los_2r   <=   1'b1;
      end
   else begin
      sfp1_los_1r   <=   sfp1_los;
      sfp1_los_2r   <=   sfp1_los_1r;
      end
end
reg            sfp2_los_1r;
reg            sfp2_los_2r;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)begin
      sfp2_los_1r   <=   1'b1;
      sfp2_los_2r   <=   1'b1;
      end
   else begin
      sfp2_los_1r   <=   sfp2_los;
      sfp2_los_2r   <=   sfp2_los_1r;
      end
end

assign   sfp1_los_flag   =   ((sfp1_los_1r==1'b1) && (sfp1_los_2r==1'b0))   ?   1'b1   :   1'b0;
assign   sfp2_los_flag   =   ((sfp2_los_1r==1'b1) && (sfp2_los_2r==1'b0))   ?   1'b1   :   1'b0;


reg         [9:0]phy1_reset_cnt;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      phy1_reset_cnt   <=   10'd1;
   else if(sfp1_los_flag==1'b1)
      phy1_reset_cnt   <=   10'd1;
   else if(phy1_reset_cnt>=10'd1)
      phy1_reset_cnt   <=   phy1_reset_cnt + 1'b1;
   else
      phy1_reset_cnt   <=   10'b0;
end
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      phy1_reset   <=   1'b1;
   else if(phy1_reset_cnt>=10'd1)
      phy1_reset   <=   1'b0;
   else
      phy1_reset   <=   1'b1;
end
//assign   sfp1_txdisable   =   1'b0;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      sfp1_txdisable   <=   1'b0;
   else if(phy1_reset_cnt>=10'd1)
      sfp1_txdisable   <=   1'b1;
   else
      sfp1_txdisable   <=   1'b0;
end

reg[9:0]phy2_reset_cnt;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      phy2_reset_cnt   <=   10'd1;
   else if(sfp2_los_flag==1'b1)
      phy2_reset_cnt   <=   10'd1;
   else if(phy2_reset_cnt>=10'd1)
      phy2_reset_cnt   <=   phy2_reset_cnt + 1'b1;
   else
      phy2_reset_cnt   <=   10'b0;
end

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      phy2_reset   <=   1'b1;
   else if(phy2_reset_cnt>=10'd1)
      phy2_reset   <=   1'b0;
   else
      phy2_reset   <=   1'b1;
end
//assign   sfp2_txdisable      =      1'b0;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
      sfp2_txdisable   <=   1'b0;
   else if(phy2_reset_cnt>=10'd1)
      sfp2_txdisable   <=   1'b1;
   else
      sfp2_txdisable   <=   1'b0;
end

//******************************************************
//LED 控制 千兆1
//******************************************************
assign phy1_led_yellow_valid   =   (phy1_led_tx   & phy1_led_rx) == 1'b0 ? 1'b1 : 1'b0;
reg[23:0]phy1_led_yellow_cnt;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     phy1_led_yellow_cnt <= 24'b0;
   else if(phy1_led_yellow_valid == 1'b1)
     phy1_led_yellow_cnt <= phy1_led_yellow_cnt + 1'b1;
   else
     phy1_led_yellow_cnt <= 24'b0;
end
//--千兆1 LED 控制(绿灯)
assign   phy1_led_green   =   (~sfp1_los |(phy1_led_link_10 & phy1_led_link_100 & phy1_led_link_1000 ))== 1'b0 ? 1'b0 : 1'b1;
//--千兆1 LED 控制(黄灯)
assign   phy1_led_yellow   =  (phy1_led_green==1'b1) ?  1'b1 : (phy1_led_yellow_cnt > 24'd10000000)? 1'b1 : 1'b0;
//--光口1 LED 控制(绿灯)
assign   sfp1_green   =   (sfp1_los |(phy1_led_link_10 & phy1_led_link_100 & phy1_led_link_1000 ))== 1'b0 ? 1'b0 : 1'b1;
//--光口1 LED 控制(黄灯)
assign   sfp1_yellow   =  (sfp1_green==1'b1) ?  1'b1 : (phy1_led_yellow_cnt > 24'd10000000)? 1'b1 : 1'b0;

//******************************************************
//LED 控制 千兆2
//******************************************************
assign phy2_led_yellow_valid   =   (phy2_led_tx   & phy2_led_rx) == 1'b0 ? 1'b1 : 1'b0;
reg[23:0]phy2_led_yellow_cnt;
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     phy2_led_yellow_cnt <= 24'b0;
   else if(phy2_led_yellow_valid == 1'b1)
     phy2_led_yellow_cnt <= phy2_led_yellow_cnt + 1'b1;
   else
     phy2_led_yellow_cnt <= 24'b0;
end
//--千兆2 LED 控制(绿灯)
assign   phy2_led_green   =   (~sfp2_los |(phy2_led_link_10 & phy2_led_link_100 & phy2_led_link_1000 ))== 1'b0 ? 1'b0 : 1'b1;
//--千兆2 LED 控制(黄灯)
assign   phy2_led_yellow   =  (phy2_led_green==1'b1) ?  1'b1 : (phy2_led_yellow_cnt > 24'd10000000)? 1'b1 : 1'b0;
//--光口2 LED 控制(绿灯)
assign   sfp2_green   =   (sfp2_los |(phy2_led_link_10 & phy2_led_link_100 & phy2_led_link_1000 ))== 1'b0 ? 1'b0 : 1'b1;
//--光口2 LED 控制(黄灯)
assign   sfp2_yellow   =  (sfp2_green==1'b1) ?  1'b1 : (phy2_led_yellow_cnt > 24'd10000000)? 1'b1 : 1'b0;

//******************************************************
//MAC1 Enable
//******************************************************
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     mac1_enable <= 1'b0;
   else if(phy1_led_link_10==1'b0 || phy1_led_link_100==1'b0 || phy1_led_link_1000==1'b0)
     mac1_enable <= 1'b1;
   else
     mac1_enable <= 1'b0;
end
//******************************************************
//MAC2 Enable
//******************************************************
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     mac2_enable <= 1'b0;
   else if(phy2_led_link_10==1'b0 || phy2_led_link_100==1'b0 || phy2_led_link_1000==1'b0)
     mac2_enable <= 1'b1;
   else
     mac2_enable <= 1'b0;
end
endmodule
