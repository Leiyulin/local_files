module id(
	input	wire[`InstAddrBus]		pc_i,
	input	wire[`InstBus]			inst_i,

	output 	reg[`RegAddrBus]	 	reg2_addr_o,
	output	reg 					reg2_read_o,
	input	wire[`RegBus]			reg2_data_i,

	output	reg[`RegAddrBus]	 	reg1_addr_o,
	output	reg 					reg1_read_o,	
	input	wire[`RegBus]			reg1_data_i,

	input	wire	rst,

	output	reg[`AluOpBus]		 	aluop_o,
	output	reg[`AluSelBus]		 	alusel_o,
	output	reg[`RegBus]		 	reg1_o,
	output	reg[`RegBus]		 	reg2_o,
	output	reg[`RegAddrBus]	 	wd_o,
	output	reg 					wreg_o,

	// --for piplined data forward push
	//ex step forward for inst with 2 intervals between
	input	wire 					ex_wreg_i,
	input 	wire[`RegBus]			ex_wdata_i,
	input 	wire[`RegAddrBus]		ex_wd_i,
	//mem step data forward for insts with 3 intervals between
	input 	wire 					mem_wreg_i,
	input 	wire[`RegBus] 			mem_wdata_i,
	input 	wire[`RegAddrBus]		mem_wd_i
	);




//trim the op, abstract func section
// note openMips uses big-endian storing
wire[5:0]	op 	= inst_i[31:26];
wire[5:0]	rs 	= inst_i[25:21];
wire[5:0]	rt 	= inst_i[20:16];
wire[5:0]	rd 	= inst_i[15:11];
wire[4:0]	sa 	= inst_i[10:6];
wire[5:0]	func	= inst_i[5:0];

//immediate num
reg[`RegBus]	imm;

reg instvalid;


//decoding process
always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		aluop_o		<=	`EXE_NOP_OP;
		alusel_o	<=	`EXE_RES_NOP;

		wd_o		<=	`NOPRegAddr;
		wreg_o		<=	`WriteDisable;
		instvalid	<=	`InstValid;
		reg1_read_o	<=	1'b0;
		reg2_read_o	<=	1'b0;
		reg1_addr_o	<=	`NOPRegAddr;
		reg2_addr_o <=	`NOPRegAddr;
		imm 		<=	32'h0;
	end else begin
		aluop_o		<=	`EXE_NOP_OP;
		alusel_o	<=	`EXE_RES_NOP;

		wd_o		<=	inst_i[15:11];		//changed
		wreg_o		<=	`WriteDisable;
		instvalid	<=	`InstInValid;		//changed
		reg1_read_o	<=	1'b0;
		reg2_read_o	<=	1'b0;
		reg1_addr_o	<=	inst_i[25:21];
		reg2_addr_o <=	inst_i[20:16];
		imm 		<=	32'h0;


// wire[5:0]	op 	= inst_i[31:26];
// wire[5:0]	rs 	= inst_i[25:21];
// wire[5:0]	rt 	= inst_i[20:16];
// wire[5:0]	rd 	= inst_i[15:11];
// wire[4:0]	sa 	= inst_i[10:6];
// wire[5:0]	func	= inst_i[5:0];

		case(op)
			`EXE_SPECIAL_INST: begin
				case(sa)
					5'b00000: begin
						case(func)
							`EXE_OR:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_OR_OP;
								alusel_o	<=	`EXE_RES_LOGIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_AND:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_AND_OP;
								alusel_o	<=	`EXE_RES_LOGIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_XOR:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_XOR_OP;
								alusel_o	<=	`EXE_RES_LOGIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_NOR:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_NOR_OP;
								alusel_o	<=	`EXE_RES_LOGIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							//alusel_o = EXE_RES_SHIFT
							`EXE_SLLV:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SLL_OP;
								alusel_o	<=	`EXE_RES_SHIFT;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_SRLV:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SRL_OP;
								alusel_o	<=	`EXE_RES_SHIFT;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_SRAV:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SRA_OP;
								alusel_o	<=	`EXE_RES_SHIFT;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_SYNC:begin
								wreg_o		<=	`WriteDisable;
								aluop_o		<=	`EXE_NOP_OP;
								alusel_o	<=	`EXE_RES_NOP;
								reg1_read_o	<=	1'b0;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end

							//move inst
							`EXE_MFHI:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_MFHI_OP;
								alusel_o	<=	`EXE_RES_MOVE;
								reg1_read_o	<=	1'b0;
								reg2_read_o	<=	1'b0;
								instvalid 	<=	`InstValid;
							end
							`EXE_MFLO:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_MFLO_OP;
								alusel_o	<=	`EXE_RES_MOVE;
								reg1_read_o	<=	1'b0;
								reg2_read_o	<=	1'b0;
								instvalid 	<=	`InstValid;
							end
							`EXE_MTHI:begin
								wreg_o		<=	`WriteDisable;
								aluop_o		<=	`EXE_MTHI_OP;
								//alusel_o	<=	`EXE_RES_NOP;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b0;
								instvalid 	<=	`InstValid;
							end
							`EXE_MTLO:begin
								wreg_o		<=	`WriteDisable;
								aluop_o		<=	`EXE_MTLO_OP;
								//alusel_o	<=	`EXE_RES_NOP;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b0;
								instvalid 	<=	`InstValid;
							end
							`EXE_MOVN:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_MOVN_OP;
								alusel_o	<=	`EXE_RES_MOVE;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;

								if (reg2_o != `ZeroWord) begin
									wreg_o <= `WriteEnable;
								end else begin
									wreg_o <= `WriteDisable;
								end
							end
							`EXE_MOVZ:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_MOVZ_OP;
								alusel_o	<=	`EXE_RES_MOVE;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;

								if (reg2_o == `ZeroWord) begin
									wreg_o <= `WriteEnable;
								end else begin
									wreg_o <= `WriteDisable;
								end
							end

							//algorithm inst
							`EXE_SLT:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SLT_OP;
								alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_SLTU:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SLTU_OP;
								alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_ADD:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_ADD_OP;
								alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_ADDU:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_ADDU_OP;
								alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_SUB:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SUB_OP;
								alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_SUBU:begin
								wreg_o		<=	`WriteEnable;
								aluop_o		<=	`EXE_SUBU_OP;
								alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_MULT:begin
								wreg_o		<=	`WriteDisable;
								aluop_o		<=	`EXE_MULT_OP;
								//alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end
							`EXE_MULTU:begin
								wreg_o		<=	`WriteDisable;
								aluop_o		<=	`EXE_MULTU_OP;
								//alusel_o	<=	`EXE_RES_ARITHMETIC;
								reg1_read_o	<=	1'b1;
								reg2_read_o	<=	1'b1;
								instvalid 	<=	`InstValid;
							end	

							default:begin
							end
						endcase
					end
					default:begin
					end
				endcase
			end
			`EXE_ORI:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_OR_OP;
				alusel_o	<=	`EXE_RES_LOGIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{16'h0, inst_i[15:0]};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end
			`EXE_ANDI:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_AND_OP;
				alusel_o	<=	`EXE_RES_LOGIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{16'h0, inst_i[15:0]};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end
			`EXE_XORI:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_XOR_OP;
				alusel_o	<=	`EXE_RES_LOGIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{16'h0, inst_i[15:0]};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end
			`EXE_LUI:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_OR_OP;
				alusel_o	<=	`EXE_RES_LOGIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{inst_i[15:0],16'h0};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end
			`EXE_PREF:begin
				wreg_o		<=	`WriteDisable;
				aluop_o		<=	`EXE_NOP_OP;
				alusel_o	<=	`EXE_RES_NOP;
				reg1_read_o	<=	1'b0;
				reg2_read_o	<=	1'b0;
				imm 		<=	{inst_i[15:0],16'h0};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end

			//ADDI ADDIU SLTI SLTIU(I TYPE WHICH OP(31:26) IS NOT SPECIAL(000000))
			`EXE_SLTI:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_SLT_OP;
				alusel_o	<=	`EXE_RES_ARITHMETIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end
			`EXE_SLTIU:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_SLTU_OP;
				alusel_o	<=	`EXE_RES_ARITHMETIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end

			`EXE_ADDI:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_ADDI_OP;
				alusel_o	<=	`EXE_RES_ARITHMETIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end
			`EXE_ADDIU:begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_ADDIU_OP;
				alusel_o	<=	`EXE_RES_ARITHMETIC;
				reg1_read_o	<=	1'b1;
				reg2_read_o	<=	1'b0;
				imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
				wd_o		<=	inst_i[20:16];
				instvalid 	<=	`InstValid;
			end

			//special2 type including: clo, clz, mul
			`EXE_SPECIAL2_INST:begin
				case(func)
					`EXE_CLZ:begin
							wreg_o		<=	`WriteEnable;
							aluop_o		<=	`EXE_CLZ_OP;
							alusel_o	<=	`EXE_RES_ARITHMETIC;
							reg1_read_o	<=	1'b1;
							reg2_read_o	<=	1'b0;
							// imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
							// wd_o		<=	inst_i[20:16];
							instvalid 	<=	`InstValid;
					end
					`EXE_CLO:begin
							wreg_o		<=	`WriteEnable;
							aluop_o		<=	`EXE_CLO_OP;
							alusel_o	<=	`EXE_RES_ARITHMETIC;
							reg1_read_o	<=	1'b1;
							reg2_read_o	<=	1'b0;
							// imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
							// wd_o		<=	inst_i[20:16];
							instvalid 	<=	`InstValid;
					end
					`EXE_MUL:begin
							wreg_o		<=	`WriteEnable;
							aluop_o		<=	`EXE_MUL_OP;
							alusel_o	<=	`EXE_RES_MUL;
							reg1_read_o	<=	1'b1;
							reg2_read_o	<=	1'b1;
							// imm 		<=	{{16{inst_i[15]}},{inst_i[15:0]}};
							// wd_o		<=	inst_i[20:16];
							instvalid 	<=	`InstValid;
					end
					default:begin
					end
				endcase
			end
			default: begin
			end
		endcase

		if (inst_i[31:21] == 11'b00000000000) begin
			if (func == `EXE_SLL) begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_SLL_OP;
				alusel_o	<=	`EXE_RES_SHIFT;
				reg1_read_o	<=	1'b0;
				reg2_read_o	<=	1'b1;
				imm[4:0] 	<=	inst_i[10:6];
				wd_o		<=	inst_i[15:11];
				instvalid 	<=	`InstValid;
			end else if(func == `EXE_SRL) begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_SRL_OP;
				alusel_o	<=	`EXE_RES_SHIFT;
				reg1_read_o	<=	1'b0;
				reg2_read_o	<=	1'b1;
				imm[4:0] 	<=	inst_i[10:6];
				wd_o		<=	inst_i[15:11];
				instvalid 	<=	`InstValid;
			end else if (func == `EXE_SRA) begin
				wreg_o		<=	`WriteEnable;
				aluop_o		<=	`EXE_SRA_OP;
				alusel_o	<=	`EXE_RES_SHIFT;
				reg1_read_o	<=	1'b0;
				reg2_read_o	<=	1'b1;
				imm[4:0] 	<=	inst_i[10:6];
				wd_o		<=	inst_i[15:11];
				instvalid 	<=	`InstValid;
			end
		end //endif
	end	//else
end //always

always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		reg1_o 		<=	`ZeroWord;

		//change for ex data forward push
	end else if ((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
		reg1_o 		<=	ex_wdata_i;
	end else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
		reg1_o 		<=	mem_wdata_i;
	end else if (reg1_read_o == 1'b1) begin
		reg1_o 		<=	reg1_data_i;
	end else if (reg1_read_o == 1'b0) begin
		reg1_o 		<=	imm;
	end else begin
		reg1_o 		<=	`ZeroWord;
	end
end

always @(*) begin
	if (rst == `RstEnable) begin
		// reset
		reg2_o 		<=	`ZeroWord;

		//change for ex data forward push
	end else if ((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
		reg2_o 		<=	ex_wdata_i;
	end else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
		reg2_o 		<=	mem_wdata_i;
	end else if (reg2_read_o == 1'b1) begin
		reg2_o 		<=	reg2_data_i;
	end else if (reg2_read_o == 1'b0) begin
		reg2_o 		<=	imm;
	end else begin
		reg2_o 		<=	`ZeroWord;
	end
end

endmodule