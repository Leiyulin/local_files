module mem_wb(
	input 	wire[`RegBus]		mem_wdata,
	input	wire[`RegAddrBus] 	mem_wd,
	input 	wire 				mem_wreg,
	input	wire 	rst,
	input 	wire 	clk,

	output  reg[`RegBus] 		wb_wdata,
	output 	reg[`RegAddrBus] 	wb_wd,
	output 	reg 				wb_wreg
	);

always @(posedge clk ) begin
	if (rst == `RstEnable) begin
		// reset
		wb_wd 	<=	`NOPRegAddr;
		wb_wdata<=	`ZeroWord;
		wb_wreg	<=	`WriteDisable;
	end
	else begin
		wb_wd 	<=	mem_wd;
		wb_wdata<=	mem_wdata;
		wb_wreg	<=	mem_wreg;	
	end
end

endmodule