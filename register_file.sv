module register_file (
    input logic clk, WE3,
    input logic [31:0] WD3,
    input logic [4:0] A1, A2, A3,

    output logic [31:0] RD1, RD2
);

    logic [31:0] register_data [31:0];

    always_ff @(posedge clk) begin
        if(WE3) register_data[A3] <= WD3; 
    end

    //Register 0 alwaysd == 0
    assign RD1 = (A1 != 0) ? register_data[A1] : 0;
    assign RD2 = (A2 != 0) ? register_data[A2] : 0;
endmodule