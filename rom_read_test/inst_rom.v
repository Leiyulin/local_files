`include "define.v"
module inst_rom(
	input	wire	ce,
	input	wire[`InstAddrBus]	addr,
	output	reg[`InstBus]		inst
	);

reg[`InstBus] inst_mem[0:`InstMemNum-1];
// size:
// cell size: 32bit
// number of cells: 2^17 = 64K
// total size:  64K * 32 bit

initial $readmemh ("inst_rom.data", inst_mem);

initial begin
	$display ("op0: %h", inst_mem[0]);
	$display ("op1: %h", inst_mem[1]);
	$display ("op2: %h", inst_mem[2]);
	$display ("op3: %h", inst_mem[3]);
	$display ("op4: %h", inst_mem[4]);
end

always @(*) begin
	if (ce == `ChipDisable) begin
		// reset
		inst 	<=	`ZeroWord;
	end
	else begin
		inst 	<=	inst_mem[addr[`InstMemNumLog2+1:2]];	
	end
end


endmodule