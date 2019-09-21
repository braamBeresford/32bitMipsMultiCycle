module double_flopr #(WIDTH=8)(
    input logic clk,
    input logic [WIDTH-1:0] in0, in1,
    output logic [WIDTH-1:0] out0, out1
);

always_ff @(posedge clk) begin
    out0 <= in0;
    out1 <= in1;
end
endmodule