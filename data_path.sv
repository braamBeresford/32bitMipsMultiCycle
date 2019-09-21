module data_path #(BIT_WIDTH = 16)(
    input logic [14:0] control_bus,
    input logic [31:0] read_data,
    input logic clk,

    output logic [31:0] write_data, addr,
    output logic zero,
    output logic [5:0] op, funct
);
    //I tried to be fancy with a big bus, may not be that elegant after all
    logic IorD, MemWrite, IRWrite;
    logic PCEn, ALUSrcA, RegWrite;
    logic RegDst, MemtoReg;
    logic [1:0] PCSrc, ALUSrcB;
    logic [2:0] ALUControl;
    logic [BIT_WIDTH-1:0] ALUOut;
	 
	logic [31:0] instr;
    // logic [4:0]  WA3;


    assign { IorD, MemWrite,  IRWrite, PCEn, ALUSrcA,
                RegWrite, RegDst, MemtoReg, PCSrc, ALUSrcB, ALUControl} = control_bus;


    logic [31:0] next_PC, PC;
    enable_flopr #(32)  PC_flip(clk, PCEn, next_PC, PC);
	mux2         #(32)  addr_sel
                        (
                            .in0(PC), .in1(ALUOut), 
                            .select(IorD), .out(addr)
                        );


    enable_flopr #(32)  curr_instr(.clk(clk), .enable(IRWrite), .in(read_data), .out(instr));
    flopr        #(32)  curr_data(.clk(clk), .in(read_data), .out(data));


    mux2         #(5)  register_write_addr
                        (
                            .select(RegDst), .in0(instr[20:16]), 
                            .in1(instr[15:11]), .out(WA3)
                        );
     mux2         #(5)  register_write_data
                        (
                            .select(MemtoReg), .in0(ALUOut), 
                            .in1(data), .out(WD3)
                        );

    register_file       reg_file
                        (
                            .clk(clk), .WE3(RegWrite), .WD3(WD3),
                            .A1(instr[25:21]), .A2(instr[20:16]),
                            .A3(WA3), .RD1(RD1), .RD2(RD2)
                        );

    //Op and function combo logic
    assign op = instr[31:26];
    assign funct = instr[5:0];
endmodule