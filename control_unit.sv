	module control_unit(
    input logic [5:0] op,
    input logic [5:0] func,
    input logic clk, zero, //Zero output from ALU for BEQ comparison

    output logic [14:0] control_bus
);

    logic IorD, MemWrite, IRWrite;
    logic PCEn, ALUSrcA, RegWrite;
    logic RegDst, MemtoReg;
    logic [1:0] PCSrc, ALUSrcB, ALUOp;
    logic [2:0] ALUControl;
	 
    assign control_bus = { IorD, MemWrite,  IRWrite, PCEn, ALUSrcA,
                            RegWrite, RegDst, MemtoReg, PCSrc, ALUSrcB, ALUControl};
    
    main_decoder main_dec (.clk(clk), .op(op), .reset(reset), .IorD(IorD), .MemWrite(MemWrite),
                            .IRWrite(IRWrite), .PCEn(PCEn), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite),
                            .RegDst(RegDst), .MemtoReg(MemtoReg), .zero(zero), .ALUSrcB(ALUSrcB),
                            .PCSrc(PCSrc), .ALUOp(ALUOp));

endmodule