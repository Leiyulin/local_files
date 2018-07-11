module pc_reg(
	input	wire	rst,
	input	wire	clk,
	output	reg		ce,
	output	reg[`InstAddrBus]	pc
	);

always @(posedge clk) begin
	if (rst == `RstEnable) begin
		// reset
		ce <= `ChipDisable;
	end else begin
		ce <= `ChipEnable;
	end
end

always @(posedge clk) begin
	if (ce == `ChipDisable) begin
		pc <= 32'h00000000;
	end else begin
		pc <= pc + 4'h4;
	end
end

endmodule
