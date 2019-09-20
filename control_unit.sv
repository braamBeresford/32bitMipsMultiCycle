module control_unit(
    input logic [5:0] op,
    input logic [5:0] func,
    input logic zero, //Zero output from ALU for BEQ comparison

    output logic IorD, MemWrite, IRWrite,
    output logic PCEn, ALUSrcA, RegWrite,
    output logic RegDst, MemtoReg,
    output logic [1:0] PCSrc, ALUSrcB,
    output logic [2:0] ALUControl
);
    
endmodule