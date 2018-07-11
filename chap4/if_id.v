//performs D flip-flop function

module if_id(
	input	wire[`InstAddrBus]	if_pc,
	input	wire[`InstBus]		if_inst,
	input	wire	rst,
	input	wire	clk,

	output	reg[`InstAddrBus]	id_pc,
	output	reg[`InstBus]		id_inst
	);

always @(posedge clk) begin
	if (rst == `RstEnable) begin
		// reset
		id_pc <= `ZeroWord;
		id_inst <= `ZeroWord;
	end else begin
		id_pc <= if_pc;
		id_inst <= if_inst;
	end
end

endmodule