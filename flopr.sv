module flopr #(WIDTH = 8) (
    input logic clk, 
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

always_ff @(posedge clk) begin
    out <= in;
end
endmodule