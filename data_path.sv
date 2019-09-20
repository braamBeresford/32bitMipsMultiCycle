module data_path #(BIT_WIDTH = 16)(
    input logic [14:0] control_bus,
    input logic [31:0] read_data,
    input logic clk,

    output logic [31:0] write_data, addr,
    output logic zero
);
    //I tried to be fancy with a big bus, may not be that elegant after all
    logic IorD, MemWrite, IRWrite;
    logic PCEn, ALUSrcA, RegWrite;
    logic RegDst, MemtoReg;
    logic [1:0] PCSrc, ALUSrcB;
    logic [2:0] ALUControl;
    logic [BIT_WIDTH-1:0] ALUOut;


    assign { IorD, MemWrite,  IRWrite, PCEn, ALUSrcA,
                RegWrite, RegDst, MemtoReg, PCSrc, ALUSrcB, ALUControl} = control_bus;


    logic [31:0] next_PC, PC;
    enable_flopr #(32)  PC_flip(clk, PCEn, next_PC, PC);
	mux2         #(32)  addr_sel
                        (
                            .in0(PC), .in1(ALUOut), 
                            .select(IorD), .out(addr)
                        );
endmodule