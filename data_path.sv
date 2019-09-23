module data_path (
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
    logic [31:0] ALUOut;
	 
	logic [31:0] instr, PCJump;


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

    double_flopr #(32)  register_read_flop
                        (
                            .clk(clk), .in0(RD1),
                            .in1(RD2), .out0(A), .out1(write_data)
                        );  

    mux2  #(32)         src_A_mux
                        (
                            .select(ALUSrcA), .in0(PC),
                            .in1(A), .out(SrcA)
                        );


    mux4  #(32)         src_B_mux
                        (
                            .select(ALUSrcB), .in0(write_data),
                            .in1(32'h4), .in2(SignImm), 
                            .in3(shift_signImm), .out(SrcB)
                        );

    sign_extend         sign_extend
                        (
                            .in(instr[15:0]), .out(SignImm)
                        );            

    shift_left_2        sl2_alu_srcB (.in(SignImm), .out(shift_signImm));
    
    ALU                 alu
                        (
                            .src_A(SrcA), .src_B(SrcB),
                            .alu_control(ALUControl), 
                            .alu_res(ALUResult), .zero(zero)
                        );

    flopr #(32)         ALU_flop
                        (
                            .clk(clk), .in(ALUResult),
                            .out(ALUOut)
                        );

    logic [31:0] shifted_address;
    shift_left_2        addr_shift
                        (
                            .in(instr[25:0]), .out(shifted_address)
                        );

    assign PCJump = {PC[31:28], shifted_address[27:0]};

    mux4 #(32)          PCSrc_mux
                        (
                            .in0(ALUResult), .in1(ALUOut),
                            .in2(PCJump), .in3(32'b0),   //We need a three way mux
									 .select(PCSrc),
                            .out(next_PC)
                        );

    //Op and function combo logic
    assign op = instr[31:26];
    assign funct = instr[5:0];

    //Just to make namign pretier
    // assign write_data = B;
endmodule