module main_decoder
            (
                input logic [5:0] op,
					 input logic clk, reset,
                
                output logic IorD, MemWrite,  IRWrite, PCEn, ALUSrcA,
                            RegWrite, RegDst, MemtoReg, zero,
                output logic [1:0] ALUSrcB, PCSrc, ALUOp
            );

    logic PCWrite, Branch;
    enum {S0, S1, S2, S3, S4, S5, S6,
            S7, S8, S9, S10, S11} currState, nextState; 

    //Next state logic
    always_comb begin
        case(currState)
            S0: nextState <= S1;
            S1: begin
                if(op == 6'b0) nextState <= S6;
                else if(op == 6'd35 || op == 6'd43) nextState <= S2; //SW or LW
                else if (op == 6'b000100) nextState <= S8; //BEQ
                else if (op == 6'b001000) nextState <= S9; //ADDI
                else if (op == 6'b000010) nextState <= S11; //J
                else nextState <= S0;
            end
            S2: begin
                if(op == 6'd35) nextState <= S3; 
                else nextState <= S5;
            end
            S3: nextState <= S4;
            S4: nextState <= S0;
            S5: nextState <= S0;
            S6: nextState <= S7;
            S7: nextState <= S0;
            S8: nextState <= S0;
            S9: nextState <= S10;
            S10: nextState <= S0;
            S11: nextState <= S0;
        endcase;
    end
    
    //Current state logic
    always_ff @(posedge clk) begin
        if(reset) currState <= S0;
        else      currState <= nextState;
    end


    //Output logic
    always_ff @(posedge clk) begin
        case(currState)
            S0: begin
                    IorD <= 0;
                    ALUSrcA <= 0;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00;
                    PCSrc <= 2'b00;
                    IRWrite <= 1;
                    MemWrite <= 0;
                    PCWrite <= 1;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S1: begin
                    ALUSrcA <= 0;
                    ALUSrcB <= 2'b11;
                    ALUOp <= 00; 
                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S2: begin
                    ALUSrcA <= 1;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S3: begin
                    IorD <= 1;
                    
                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S4: begin
                    RegDst <= 0;
                    MemtoReg <= 1;
                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 1;
            end
            S5: begin
                    IorD <= 1;

                    IRWrite <= 0;
                    MemWrite <= 1;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S6: begin
                    ALUSrcA <= 1;
                    ALUSrcB <= 2'b00;
                    ALUOp <= 2'b10;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S7: begin
                    RegDst <= 1;
                    MemtoReg <= 0;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 1;
            end
            S8: begin
                    ALUSrcA <= 1;
                    ALUSrcB <= 2'b00;
                    ALUOp <= 2'b01;
                    PCSrc <= 2'b01;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 1;
                    RegWrite <= 0;
            end
            S9: begin
                    ALUSrcA <= 1;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 0;
            end
            S10: begin
                    RegDst <= 0;
                    MemtoReg <= 0;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 0;
                    Branch <= 0;
                    RegWrite <= 1;
            end
            S11: begin
                    PCSrc <= 10;

                    IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 1;
                    Branch <= 0;
                    RegWrite <= 0;
            end
				default: begin
						  IRWrite <= 0;
                    MemWrite <= 0;
                    PCWrite <= 1;
                    Branch <= 0;
                    RegWrite <= 0;
				end
        endcase
    end

    logic temp;
    assign temp = Branch && zero;
    assign PCEn = PCWrite || temp;
endmodule