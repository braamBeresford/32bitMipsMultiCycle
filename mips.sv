module mips(
    input logic clk, reset, mem_write,
    input logic [31:0] read_data,

    output logic [31:0] write_data, addr
);

    
    data_path #(32)    DP(
                    .control_bus(bus), .read_data(read_data),
                    .clk(clk), .write_data(write_data), .addr(addr),
                    .zero(zero), .op(op), .funct(funct)
                    );

    control_unit  CU(
                    .op(op), .func(func),
                    .clk(clk), .zero(zero),
                    .control_bus(bus)
                    );
    

endmodule

