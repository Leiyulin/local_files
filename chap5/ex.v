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
	output  reg 			 	wreg_o
	);

reg[`RegBus]	logicout;
reg[`RegBus]	shiftres;

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
		default:	begin
			wdata_o 	<=	`ZeroWord;
		end
	endcase
end

endmodule