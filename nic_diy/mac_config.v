
//double mac config, like a top file of mac_config_sub.v file
module mac_config
     (
     //***********************************************************
     //--Clock And Reset Signals
     //***********************************************************
     input                               clk                     ,   
     input                               rst_n                   ,   
     //***********************************************************
     //--MAC A Control Interface Signals 
     //***********************************************************
     output                              config_clk_A            ,   
     input        [47:0]                 mac_addr_A              ,   
     output       [7:0]                  address_A               ,   
     output                              write_A                 ,   
     output                              read_A                  ,   
     output       [31:0]                 writedata_A             ,   
     input        [31:0]                 readdata_A              ,   
     input                               waitrequest_A           , 
     input                               mac_enable_A            ,   
     //***********************************************************
     //--MAC B Control Interface Signals 
     //*********************************************************** 
     output                              config_clk_B            ,   
     input        [47:0]                 mac_addr_B              ,   
     output       [7:0]                  address_B               ,   
     output                              write_B                 ,   
     output                              read_B                  ,   
     output       [31:0]                 writedata_B             ,   
     input        [31:0]                 readdata_B              ,   
     input                               waitrequest_B           ,
     input                               mac_enable_B   
     );

     
mac_config_sub MAC_CONFIG_A 
      (
      .clk              (clk                ),         // control_port_clock_connection.clk
      //cool trick using & when bound a port!
      .rst_n            (rst_n&mac_enable_A ),         //              reset_connection.reset
      .mac_addr         (mac_addr_A         ),
//***************************************************************************
      .config_clk       (config_clk_A       ),
      .readdata         (readdata_A         ),         //                  control_port.readdata
      .read             (read_A             ),         //                              .read
      .writedata        (writedata_A        ),         //                              .writedata
      .write            (write_A            ),         //                              .write
      .waitrequest      (waitrequest_A      ),         //                              .waitrequest
      .address          (address_A          )          //                              .address
      );
      
mac_config_sub MAC_CONFIG_B 
      (
      .clk              (clk                ),         // control_port_clock_connection.clk
      .rst_n            (rst_n&mac_enable_B ),         //              reset_connection.reset
      .mac_addr         (mac_addr_B         ),
//***************************************************************************
      .config_clk       (config_clk_B       ),
      .readdata         (readdata_B         ),         //                  control_port.readdata
      .read             (read_B             ),         //                              .read
      .writedata        (writedata_B        ),         //                              .writedata
      .write            (write_B            ),         //                              .write
      .waitrequest      (waitrequest_B      ),         //                              .waitrequest
      .address          (address_B          )          //                              .address
      );

endmodule 
