module ex_mem (
	input	wire[`RegBus]		ex_wdata,
	input	wire[`RegAddrBus]	ex_wd,
	input	wire				ex_wreg,

	input	wire	rst,
	input	wire 	clk,

	output 	reg[`RegBus]	 	mem_wdata,
	output 	reg[`RegAddrBus] 	mem_wd,
	output 	reg 				mem_wreg
	);

always @(posedge clk) begin
	if (rst == `RstEnable) begin
		// reset
		mem_wd 		<=	`NOPRegAddr;
		mem_wreg	<=	`WriteDisable;
		mem_wdata	<=	`ZeroWord;
	end else begin
		mem_wd 		<=	ex_wd;
		mem_wreg	<=	ex_wreg;
		mem_wdata	<=	ex_wdata;
	end
end

endmodule