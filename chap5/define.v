`define RstDisable		1'b0
`define RstEnable		1'b1
`define ChipDisable		1'b0
`define ChipEnable		1'b1

`define	WriteEnable		1'b1
`define WriteDisable	1'b0

`define	ReadEnable		1'b1
`define	ReadDisable		1'b0

`define	ZeroWord		32'h00000000

`define AluOpBus		7:0
`define AluSelBus		2:0

`define	InstValid		1'b1
`define InstInValid		1'b0

//**********
`define InstAddrBus		31:0
`define InstBus 		31:0

`define InstMemNum		8
`define InstMemNumLog2	3

//define for regfile
`define	RegBus			31:0
`define	RegNum			32
`define RegAddrBus		4:0
`define	RegNumLog2		5
`define	NOPRegAddr		5'b00000

//-- macro for instructions
//aluop

`define EXE_NOP_OP		8'b00000000

//R type special
`define EXE_AND_OP		8'b00100100
`define	EXE_OR_OP  		8'b00100101
`define	EXE_XOR_OP		8'b00100110
`define	EXE_NOR_OP 		8'b00100111


`define	EXE_SLL_OP 		8'b00000000

`define	EXE_SRL_OP 		8'b00000010

`define	EXE_SRA_OP 		8'b00000011




//alusel
`define	EXE_RES_LOGIC	3'b001
`define	EXE_RES_NOP		3'b000
`define	EXE_RES_SHIFT	3'b010 //changable

//special op[31:26]
`define	EXE_SPECIAL_INST 		6'b000000

//R type special inst: these define is for func = inst[5:0]
`define EXE_AND 		6'b100100
`define	EXE_OR  		6'b100101
`define	EXE_XOR			6'b100110
`define	EXE_NOR 		6'b100111
//I type: definitions for op = inst[31:26]
`define	EXE_ANDI 		6'b001100
`define	EXE_ORI 		6'b001101
`define	EXE_XORI 		6'b001110
`define	EXE_LUI 		6'b001111

`define	EXE_SLL 		6'b000000
`define	EXE_SLLV 		6'b000100

`define	EXE_SRL 		6'b000010
`define	EXE_SRLV 		6'b000110

`define	EXE_SRA 		6'b000011
`define	EXE_SRAV		6'b000111

`define	EXE_SYNC 		6'b001111
`define	EXE_PREF		6'b110011

`define	EXE_NOP 		6'b000000
