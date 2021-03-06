
module openmips (
	input	wire	rst,
	input	wire	clk,
	input	wire[`RegBus]	rom_data_i,

	// note the output here is wire type
	output	wire[`RegBus]	rom_addr_o,
	output	wire	rom_ce_o
	);

//wire for pc_reg instantiation
wire[`InstAddrBus]	pc;

//wire for if_id
wire[`InstAddrBus]	id_pc_i;
wire[`InstBus]		id_inst_i;

//wire for id and regfile
wire	reg1_read;
wire	reg2_read;
wire[`RegBus]	reg1_data;
wire[`RegBus]	reg2_data;
wire[`RegAddrBus]	reg1_addr;
wire[`RegAddrBus]	reg2_addr;

//wire for id and id/ex
wire[`AluOpBus]		id_aluop_o;
wire[`AluSelBus]	id_alusel_o;
wire[`RegBus]		id_reg1_o;
wire[`RegBus]		id_reg2_o;
wire				id_wreg_o;
wire[`RegAddrBus]	id_wd_o;

//wire for mem/wb
wire				wb_wreg_i;
wire[`RegAddrBus]	wb_wd_i;
wire[`RegBus]		wb_wdata_i;

// wire for id/ex and ex
wire[`AluOpBus]		ex_aluop_i;
wire[`AluSelBus]	ex_alusel_i;
wire[`RegBus]		ex_reg1_i;
wire[`RegBus]		ex_reg2_i;
wire				ex_wreg_i;
wire[`RegAddrBus]	ex_wd_i;

// wire for ex and ex/mem
wire				ex_wreg_o;
wire[`RegAddrBus]	ex_wd_o;
wire[`RegBus]		ex_wdata_o;

//wire for ex/mem and mem
wire				mem_wreg_i;
wire[`RegAddrBus]	mem_wd_i;
wire[`RegBus]		mem_wdata_i;

//wire for mem and mem/wb
wire				mem_wreg_o;
wire[`RegAddrBus]	mem_wd_o;
wire[`RegBus]		mem_wdata_o;


// // // for ex data forward
// wire				ex_wreg_forward_o;
// wire[`RegBus]		ex_wd_forward_o;
// wire[`RegAddrBus]	ex_wdata_forward_o;

// //wireegor mem data forward
// wire				mem_wreg_forward_o;
// wire[`RegBus]		mem_wd_forward_o;
// wire[`RegAddrBus]	mem_wdata_forward_o;

//instantiation
pc_reg pc_reg0(
	.rst(rst),
	.clk(clk),
	.ce(rom_ce_o),
	.pc(pc)
	);

assign rom_addr_o = pc;
//pc is an address of Inst

if_id if_id0(
	.if_pc(pc),
	.if_inst(rom_data_i),
	.rst(rst),
	.clk(clk),
	.id_pc(id_pc_i),
	.id_inst(id_inst_i)
	);

id id0(
	.pc_i(id_pc_i),
	.inst_i(id_inst_i),

	.reg2_addr_o(reg2_addr),
	.reg2_read_o(reg2_read),
	.reg2_data_i(reg2_data),

	.reg1_addr_o(reg1_addr),
	.reg1_read_o(reg1_read),
	.reg1_data_i(reg1_data),

	.rst(rst),

	.aluop_o(id_aluop_o),
	.alusel_o(id_alusel_o),
	.reg1_o(id_reg1_o),
	.reg2_o(id_reg2_o),
	.wd_o(id_wd_o),
	.wreg_o(id_wreg_o),
	
	.ex_wreg_i(ex_wreg_o),
	.ex_wdata_i(ex_wdata_o),
	.ex_wd_i(ex_wd_o),

	.mem_wreg_i(mem_wreg_o),
	.mem_wdata_i(mem_wdata_o),
	.mem_wd_i(mem_wd_o)
	);


regfile regfile1(
	.re1(reg1_read),
	.raddr1(reg1_addr),
	.rdata1(reg1_data),

	.re2(reg2_read),
	.raddr2(reg2_addr),
	.rdata2(reg2_data),

	.we(wb_wreg_i),
	.waddr(wb_wd_i),
	.wdata(wb_wdata_i),

	.rst(rst),
	.clk(clk)
	);


id_ex id_ex0(
	.id_aluop(id_aluop_o),
	.id_alusel(id_alusel_o),
	.id_reg1(id_reg1_o),
	.id_reg2(id_reg2_o),
	.id_wd(id_wd_o),
	.id_wreg(id_wreg_o),

	.rst(rst),
	.clk(clk),

	.ex_aluop(ex_aluop_i),
	.ex_alusel(ex_alusel_i),
	.ex_reg1(ex_reg1_i),
	.ex_reg2(ex_reg2_i),
	.ex_wd(ex_wd_i),
	.ex_wreg(ex_wreg_i)


	);

//connect ex and ex/mem
wire 			ex_whilo_o;
wire[`RegBus]	ex_hi_o;
wire[`RegBus] 	ex_lo_o;

//connect hilo to ex (loopback)
//wire 			hilo_to_ex_whilo;
wire[`RegBus]	hilo_to_ex_hi;
wire[`RegBus] 	hilo_to_ex_lo;

// //connect wb to ex(loopback)
// wire 			wb_to_ex_whilo;
// wire[`RegBus]	wb_to_ex_hi;
// wire[`RegBus]	wb_to_ex_lo;

//connect ex/mem to mem
wire 			ex_mem_to_mem_whilo;
wire[`RegBus]	ex_mem_to_mem_hi;
wire[`RegBus]	ex_mem_to_mem_lo;

// //connect mem to mem/wb block
wire 			mem_to_wb_whilo;
wire[`RegBus]	mem_to_wb_hi;
wire[`RegBus]	mem_to_wb_lo;

// //connect wb to hilo 
wire 			wb_to_hilo_whilo;
wire[`RegBus]	wb_to_hilo_hi;
wire[`RegBus]	wb_to_hilo_lo;

ex ex0(
	.aluop_i(ex_aluop_i),
	.alusel_i(ex_alusel_i),
	.reg1_i(ex_reg1_i),
	.reg2_i(ex_reg2_i),
	.wd_i(ex_wd_i),
	.wreg_i(ex_wreg_i),

	.rst(rst),

	.wdata_o(ex_wdata_o),
	.wd_o(ex_wd_o),
	.wreg_o(ex_wreg_o),

		//input for hilo
	.hi_i(hilo_to_ex_hi),
	.lo_i(hilo_to_ex_lo),

	.wb_whilo_i(wb_to_hilo_whilo),
	.wb_hi_i(wb_to_hilo_hi),
	.wb_lo_i(wb_to_hilo_lo),

	.mem_whilo_i(mem_to_wb_whilo),
	.mem_hi_i(mem_to_wb_hi),
	.mem_lo_i(mem_to_wb_lo),

	//output for hilo
	.whilo_o(ex_whilo_o),
	.hi_o(ex_hi_o),
	.lo_o(ex_lo_o)
	// .wdata_o(ex_wdata_forward_o),
	// .wd_o(ex_wd_forward_o),
	// .wreg_o(ex_wreg_forward_o)
	);

// //connect ex/mem to mem
// wire 			ex_mem_to_mem_whilo;
// wire[`RegBus]	ex_mem_to_mem_hi;
// wire[`RegBus]	ex_mem_to_mem_lo;

ex_mem ex_mem0(
	.ex_wdata(ex_wdata_o),
	.ex_wd(ex_wd_o),
	.ex_wreg(ex_wreg_o),

	.rst(rst),
	.clk(clk),

	.mem_wdata(mem_wdata_i),
	.mem_wd(mem_wd_i),
	.mem_wreg(mem_wreg_i),

	//hilo
	.ex_whilo(ex_whilo_o),
	.ex_hi(ex_hi_o),
	.ex_lo(ex_lo_o),

	.mem_whilo(ex_mem_to_mem_whilo),
	.mem_hi(ex_mem_to_mem_hi),
	.mem_lo(ex_mem_to_mem_lo)
	);

// //connect mem to mem/wb block
// wire 			mem_to_wb_whilo;
// wire[`RegBus]	mem_to_wb_hi;
// wire[`RegBus]	mem_to_wb_lo;

mem mem0(
	.wdata_i(mem_wdata_i),
	.wd_i(mem_wd_i),
	.wreg_i(mem_wreg_i),

	.rst(rst),

	.wdata_o(mem_wdata_o),
	.wd_o(mem_wd_o),
	.wreg_o(mem_wreg_o),

	//hilo
	.whilo_i(ex_mem_to_mem_whilo),
	.hi_i(ex_mem_to_mem_hi),
	.lo_i(ex_mem_to_mem_lo),

	.whilo_o(mem_to_wb_whilo),
	.hi_o(mem_to_wb_hi),
	.lo_o(mem_to_wb_lo)



	// .wdata_o(mem_wdata_forward_o),
	// .wd_o(mem_wd_forward_o),
	// .wreg_o(mem_wreg_forward_o)
	);

// assign mem_wdata_i 		= mem_wdata_o;
// assign mem_wd_i 		= mem_wd_o;
// assign mem_wreg_i		= mem_wreg_o;


// //connect wb to hilo 
// wire 			wb_to_hilo_whilo;
// wire[`RegBus]	wb_to_hilo_hi;
// wire[`RegBus]	wb_to_hilo_lo;

mem_wb mem_wb0(
	.mem_wdata(mem_wdata_o),
	.mem_wd(mem_wd_o),
	.mem_wreg(mem_wreg_o),

	.rst(rst),
	.clk(clk),

	.wb_wdata(wb_wdata_i),
	.wb_wd(wb_wd_i),
	.wb_wreg(wb_wreg_i),

	//hilo
	.mem_whilo(mem_to_wb_whilo),
	.mem_hi(mem_to_wb_hi),
	.mem_lo(mem_to_wb_lo),

	.wb_whilo(wb_to_hilo_whilo),
	.wb_hi(wb_to_hilo_hi),
	.wb_lo(wb_to_hilo_lo)
	);

hilo_reg hilo_reg0(
	.clk(clk),
	.rst(rst),

	.we(wb_to_hilo_whilo),
	.hi_i(wb_to_hilo_hi),
	.lo_i(wb_to_hilo_lo),

	.hi_o(hilo_to_ex_hi),
	.lo_o(hilo_to_ex_lo)
	);
endmodule
