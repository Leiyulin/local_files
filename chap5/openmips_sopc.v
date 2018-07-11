module openmips_sopc(
	input 	wire	clk,
	input	wire	rst
	);

//set wire
wire[`InstBus]		data;
wire[`InstAddrBus]	addr;
wire				ce_con;
//init
inst_rom inst_rom0(
	.ce(ce_con),
	.addr(addr),
	.inst(data)
	);

openmips openmips0(
	.rst(rst),
	.clk(clk),
	.rom_data_i(data),
	.rom_addr_o(addr),
	.rom_ce_o(ce_con)
	);

endmodule