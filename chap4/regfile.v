
module regfile(

	//read port 1
	input	wire 	re1,
	input	wire[`RegAddrBus]	raddr1,
	output	reg[`RegBus] 		rdata1,

	//read port 2
	input	wire	re2,
	input	wire[`RegAddrBus]	raddr2,
	output	reg[`RegBus] 		rdata2,

	//write port
	input	wire	we,
	input	wire[`RegAddrBus]	waddr,
	input	wire[`RegBus]		wdata,

	input	wire	rst,
	input	wire	clk
	);

	reg[`RegBus]	regs[0:`RegNum-1];

	//writing process
	always @(posedge clk) begin
		if (rst == `RstDisable) begin
			// reset
			if ((we == `WriteEnable) && (waddr !== `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
				// the number in bracket [] automately change to decimal
			end
		end
	end

	//reading process port 1
	always @(*) begin
		if (rst == `RstEnable) begin
			// reset
			rdata1 <= `ZeroWord;
		end else if ((raddr1 == waddr) && (we == `WriteEnable)) begin
			rdata1 <= wdata;
		end else if (re1 == `ReadEnable) begin
			rdata1 <= regs[raddr1];
		end else begin
			rdata1 <= `ZeroWord;
		end
	end

	//reading process port 2
	always @(posedge clk) begin
		if (rst == `RstEnable) begin
			// reset
			rdata2 <= `ZeroWord;
		end else if ((raddr1 == waddr) && (we == `WriteEnable)) begin
			rdata2 <= wdata;
		end else if (re2 == `ReadEnable) begin
			rdata2 <= regs[raddr2];
		end else begin
			rdata2 <= `ZeroWord;
		end
	end
endmodule