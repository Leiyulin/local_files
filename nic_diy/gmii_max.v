// this mode determines whether using gmii or mii mode 

module gmii_mux
  (
      input                               clk_125M                ,   
      input                               rst_n                   ,   
     
      //--Clock
      //IP core's clk is not from clk PPL derectly, from mux block!!!
      //this 2 clk control mux block and IP transmit speed
      output                              tx_clk                  ,   
      output                              rx_clk                  ,   //125M/25M/2.5M
      
      //--from IP core
      input                               eth_mode                ,   //                              .eth_mode
      input                               ena_10                  ,   //                              .ena_10
//********************************************************************************    
// rx and tx mux-block with MAC ip core(altera) 
      //--GMII RX
      output    reg[7:0]                  gm_rx_d                 ,   //           mac_gmii_connection.gmii_rx_d
      output    reg                       gm_rx_dv                ,   //                              .gmii_rx_dv
      output    reg                       gm_rx_err               ,   //                              .gmii_rx_err
      //--GMII TX
      input        [7:0]                  gm_tx_d                 ,   //                              .gmii_tx_d
      input                               gm_tx_en                ,   //                              .gmii_tx_en
      input                               gm_tx_err               ,   //                              .gmii_tx_err
//*********************************************************************************
      // //--MII RX
      // output    reg[3:0]                  m_rx_d                  ,   //            mac_mii_connection.mii_rx_d
      // output    reg                       m_rx_en                 ,   //                              .mii_rx_dv
      // output    reg                       m_rx_err                ,   //                              .mii_rx_err
      // //--MII TX
      // input        [3:0]                  m_tx_d                  ,   //                              .mii_tx_d
      // input                               m_tx_en                 ,   //                              .mii_tx_en
      // input                               m_tx_err                ,   //                              .mii_tx_err
      // output    reg                       m_rx_crs                ,   //                              .mii_crs
      // output    reg                       m_rx_col                ,   //                              .mii_col
//********************************************************************************
// rx and tx MAC with PHY
// this GMII interface define, we know it backward support MII.
      //--RX
      input                               phy_rx_clk              ,   //                           PHY.rx_clk
      input                               rx_dv                   ,   //                           PHY.rx_dv
      input        [7:0]                  rxd                     ,   //                           PHY.rxd
      input                               rx_er                   ,   //                           PHY.rx_err
      //--TX
      output                              gtx_clk                 ,   //                           PHY.gtx_clk
      input                               phy_tx_clk              ,   //                           PHY.tx_clk
      output    reg                       tx_en                   ,   //                           PHY.tx_en
      output    reg[7:0]                  txd                     ,   //                           PHY.txd
      output    reg                       tx_er                   ,   //                           PHY.tx_err
      //--
      input                               crs                     ,   
      input                               col
  );
////*************************************************
////--TX
////*************************************************
//
//assign  tx_en     = (eth_mode==1'b1) ? gm_tx_en : m_tx_en;
//assign  txd       = (eth_mode==1'b1) ? gm_tx_d  : {4'b0,m_tx_d};
//assign  tx_er     = (eth_mode==1'b1) ? gm_tx_err: m_tx_err;
//assign  tx_clk    = (eth_mode==1'b1) ? clk_125M : phy_tx_clk;
//assign  gtx_clk   = (eth_mode==1'b1) ? clk_125M : 1'b0;
//*************************************************
//--RX
//*************************************************
//--GMII
//assign  gm_rx_dv  = (eth_mode==1'b1) ? rx_dv    : 1'b0;
//assign  gm_rx_d   = (eth_mode==1'b1) ? rxd      : 8'b0;
//assign  gm_rx_err = (eth_mode==1'b1) ? rx_er    : 1'b0;
////--MII
//assign  m_rx_en   = (eth_mode==1'b0) ? rx_dv    : 1'b0;
//assign  m_rx_d    = (eth_mode==1'b0) ? rxd[3:0] : 4'b0;
//assign  m_rx_err  = (eth_mode==1'b0) ? rx_er    : 1'b0;
//assign  m_rx_crs  = crs;
//assign  m_rx_col  = col;
////--Clock
//assign  rx_clk    =  phy_rx_clk;


//*************************************************
//--TX
//*************************************************
assign  tx_clk    = (eth_mode==1'b1) ? clk_125M : phy_tx_clk;
//assign  gtx_clk   = (eth_mode==1'b1) ? clk_125M : 1'b0;
assign  gtx_clk   =  clk_125M ;

//eth_mode -> determine 1GMbps(GMII) or 10Mbps(MII) gm_tx_en / m_tx_en => tx_en
always @(posedge clk_125M)
begin
    if(eth_mode==1'b1)
        tx_en    <=  gm_tx_en;
    else
        tx_en    <=  m_tx_en;
end

// case(eth_mode): txd <= gm_tx_d / {4'b0,m_tx_d}
always @(posedge clk_125M)
begin
    if(eth_mode==1'b1)
        txd    <=  gm_tx_d;
    else
        txd    <=  {4'b0,m_tx_d};
end

// case(eth_mode): tx_er <= gm_tx_err / m_tx_err
always @(posedge clk_125M)
begin
    if(eth_mode==1'b1)
        tx_er    <=  gm_tx_err;
    else
        tx_er    <=  m_tx_err;
end

//*************************************************
//--RX
//*************************************************
//--Clock
assign  rx_clk    =  phy_rx_clk;
//--GMII

// gm_rx_dv = (eth_mode) ? rx_dv : 1'b0
always @(posedge rx_clk )
begin
    if(eth_mode==1'b1)
        gm_rx_dv    <=  rx_dv;
    else
        gm_rx_dv    <=  1'b0; //invalid? why
end

// gm_rx_d = (eth_mode) ? rxd : 1'b0
always @(posedge rx_clk)
begin
    if(eth_mode==1'b1)
        gm_rx_d    <=  rxd;
    else
        gm_rx_d    <=  1'b0;
end

// gm_rx_err = (eth_mode) ? rx_er : 1'b0
always @(posedge rx_clk)
begin
    if(eth_mode==1'b1)
        gm_rx_err    <=  rx_er;
    else
        gm_rx_err    <=  1'b0;
end

//--MII

// m_rx_en = (!eth_mode) ? rx_dv : 1'b0
always @(posedge rx_clk)
begin
    if(eth_mode==1'b0)
        m_rx_en    <=  rx_dv;
    else
        m_rx_en    <=  1'b0;
end


always @(posedge rx_clk)
begin
    if(eth_mode==1'b0)
        m_rx_d    <=  rxd[3:0];
    else
        m_rx_d    <=  1'b0;
end
always @(posedge rx_clk)
begin
    if(eth_mode==1'b0)
        m_rx_err    <=  rx_er;
    else
        m_rx_err    <=  1'b0;
end
always @(posedge rx_clk)
begin
    if(eth_mode==1'b0)
        m_rx_crs    <=  crs;
    else
        m_rx_crs    <=  1'b0;
end
always @(posedge rx_clk)
begin
    if(eth_mode==1'b0)
        m_rx_col    <=  col;
    else
        m_rx_col    <=  1'b0;
end
endmodule 
