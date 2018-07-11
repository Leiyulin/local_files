
// !!!mac_tx_ctrl and mac_rx_ctrl is for synchronization
// please comparely read mac_rx_ctrl.v and mac_rx_ctrl.v

module mac_tx_ctrl
  #
  (
     parameter         DATA_WIDTH         =   8
  )
  (
     input                               clk                     ,   
     input                               rst_n                   ,   
     
     //--MAC (altera IP) Interface
     output                              ff_tx_clk               ,   
     output    reg[DATA_WIDTH-1:0]       ff_tx_data              ,   
     output    reg                       ff_tx_sop               ,   
     output    reg                       ff_tx_eop               ,   
     output    reg                       ff_tx_wren              ,   
     output                              ff_tx_err               ,   
     
     // dont have this mod signal in IP used in this project
     output    reg[1:0]                  ff_tx_mod               ,   
     

     //--
     input        [DATA_WIDTH-1:0]       client_txd              ,   
     input        [2:0]                  client_tx_valid         ,   
     input        [1:0]                  client_tx_mod
  );

//*******************************************
//--
//*******************************************

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     ff_tx_data <= {DATA_WIDTH{1'b0}};
   else 
     ff_tx_data <= client_txd;
end

//following signals can changed external
always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     ff_tx_wren <= 1'b0;
   else 
     ff_tx_wren <= client_tx_valid[2];
end

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     ff_tx_sop <= 1'b0;
   else 
     ff_tx_sop <= client_tx_valid[1];
end

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     ff_tx_eop <= 1'b0;
   else 
     ff_tx_eop <= client_tx_valid[0];
end

always @ (posedge clk or negedge rst_n)begin
   if(!rst_n)
     ff_tx_mod <= 2'b0;
   else 
     ff_tx_mod <= client_tx_mod;
end


assign  ff_tx_err = 1'b0;
assign  ff_tx_clk = clk;
endmodule 
