module shift_left_2 (input logic [31:0] in, output logic [31:0] out);

    assign out = {in[29:0], 2'b00};
endmodule