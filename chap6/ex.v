module ex(
	input	wire[`AluOpBus]		aluop_i,
	input	wire[`AluSelBus]	alusel_i,
	input	wire[`RegBus]	 	reg1_i,
	input 	wire[`RegBus]	 	reg2_i,
	input	wire[`RegAddrBus] 	wd_i,
	input 	wire	wreg_i,

	input 	wire 	rst,

	output  reg[`RegBus] 		wdata_o,
	output  reg[`RegAddrBus] 	wd_o,
	output  reg 			 	wreg_o,

	//hilo
	input	wire[`RegBus]		hi_i,
	input 	wire[`RegBus]		lo_i,

	input	wire				wb_whilo_i,
	input 	wire[`RegBus]		wb_hi_i,
	input 	wire[`RegBus]		wb_lo_i,
	input 	wire				mem_whilo_i,
	input  	wire[`RegBus]		mem_hi_i,
	input 	wire[`RegBus]		mem_lo_i,

	output 	reg 				whilo_o,
	output 	reg[`RegBus]		hi_o,
	output 	reg[`RegBus]		lo_o
	);

reg[`RegBus]	logicout;
reg[`RegBus]	shiftres;

reg[`RegBus]	moveres;
reg[`RegBus]	HI;
reg[`RegBus]	LO;


//hilo dealing for data relativity
always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		{HI,LO} <= {`ZeroWord, `ZeroWord};
	end
	else if (mem_whilo_i == `WriteEnable) begin
		{HI,LO} <= {mem_hi_i, mem_lo_i};
	end else if (wb_whilo_i == `WriteEnable) begin
		{HI, LO} <= {wb_hi_i,wb_lo_i};
	end else begin
		{HI,LO} <= {hi_i, lo_i};
	end
end
//move operation
always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		moveres <= `ZeroWord;
	end else begin
		moveres <=	`ZeroWord;
		case (aluop_i)
			`EXE_MFHI_OP: begin
				moveres <= HI;
			end
			`EXE_MFLO_OP: begin
				moveres <= LO;
			end
			`EXE_MOVZ_OP: begin
				moveres <= reg1_i;
			end
			`EXE_MOVN_OP: begin
				moveres <= reg1_i;
			end
			default: begin
			end
		endcase
	end
end

// logic alrithm
always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		logicout 	<=	`ZeroWord;
	end else begin
		case (aluop_i)
			`EXE_OR_OP:begin
				logicout	<=	reg1_i | reg2_i;
			end
			`EXE_AND_OP:begin
				logicout	<=	reg1_i & reg2_i;
			end
			`EXE_NOR_OP:begin
				logicout	<=	~(reg1_i | reg2_i);
			end
			`EXE_XOR_OP:begin
				logicout	<=	reg1_i ^ reg2_i;
			end 
			// `EXE_SLL_OP 

			// `EXE_SRL_OP 

			// `EXE_SRA_OP 
			default: begin
				logicout	<=	`ZeroWord;
			end
		endcase
	end // endif
end  //endalways

//shifting process
always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		shiftres	<=	`ZeroWord;
	end else begin
		case(aluop_i)
			`EXE_SLL_OP:begin
				shiftres	<=	reg2_i << reg1_i[4:0];
			end
			`EXE_SRL_OP:begin
				shiftres	<=	reg2_i >> reg1_i[4:0];
			end
			`EXE_SRA_OP:begin
				shiftres	<=	({32{reg2_i[31]}} << (6'd32-{1'b0,reg1_i[4:0]})) | reg2_i >> reg1_i[4:0];
			end 
			default:begin
			end
		endcase
	end  //endelse
end // endalways

always @(*) begin
	wd_o 	<=	wd_i;
	wreg_o 	<=	wreg_i;
	case (alusel_i)
		`EXE_RES_LOGIC:	begin
			wdata_o 	<=	logicout;
		end
		`EXE_RES_SHIFT: begin
			wdata_o		<=	shiftres;
		end
		`EXE_RES_MOVE: begin
			wdata_o		<= 	moveres;
		end
		default:	begin
			wdata_o 	<=	`ZeroWord;
		end
	endcase
end

always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		whilo_o		<= 	`WriteDisable;
		hi_o		<= 	`ZeroWord;
		lo_o		<= 	`ZeroWord;
	end
	else if (aluop_i == `EXE_MTHI_OP) begin
		whilo_o		<= 	`WriteEnable;
		hi_o 		<= 	reg1_i;
		lo_o 		<= 	LO;
	end else if (aluop_i == `EXE_MTLO_OP) begin
		whilo_o 	<= 	`WriteEnable;
		hi_o 		<= 	HI;
		lo_o 		<= 	reg1_i;
	end else begin
		whilo_o 	<=  `WriteDisable;
		hi_o 		<= 	`ZeroWord;
		lo_o 		<= 	`ZeroWord;
	end
end
endmodule