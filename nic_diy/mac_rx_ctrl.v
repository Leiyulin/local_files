

// !!!mac_tx_ctrl and mac_rx_ctrl is for synchronization
// please comparely read mac_rx_ctrl.v and mac_rx_ctrl.v
module mac_rx_ctrl
  #
  (
     parameter         DATA_WIDTH         =   8
  )
  (
     input                               clk                     ,   
     input                               rst_n                   ,   
     
     //--MAC Interface
     output                              ff_rx_clk               ,   
     input        [DATA_WIDTH-1:0]       ff_rx_data              ,   
     input                               ff_rx_sop               ,   
     input                               ff_rx_eop               ,   
     input                               ff_rx_dval              ,   
     input        [1:0]                  ff_rx_mod               ,   
     //--
     output     reg[DATA_WIDTH-1:0]      client_rxd              ,   
     output     reg[2:0]                 client_rx_valid         ,   
     output     reg[1:0]                 client_rx_mod
  );
 
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     client_rxd <= {DATA_WIDTH{1'b0}};
   else
     client_rxd <= ff_rx_data;
end

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     client_rx_valid <= 3'b0;
   else
     client_rx_valid <= {ff_rx_dval,ff_rx_sop,ff_rx_eop};
end

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     client_rx_mod <= 2'b0;
   else
     client_rx_mod <= ff_rx_mod;
end

assign ff_rx_clk = clk;
endmodule 
