//This top module is provided by "igital Design and Computer Architecture" 
//for compatability with they test bench. All modules are my original HDL.
module top(
			input  logic       clk, reset,
			output logic [31:0] writedata, adr,
			output logic       memwrite
		);
		
		logic [31:0] readdata;
		// instantiate processor and memories
		mips mips(.clk(clk), .reset(reset), .addr(adr),
			 .write_data(writedata), .mem_write(memwrite), .read_data(readdata));
		
		mem mem(clk, memwrite, adr, writedata, readdata);
		
endmodule

module mem( input logic       clk, we,
							input  logic [31:0] a, wd,
							output logic [31:0] rd);
							
	logic [31:0] RAM[63:0];

initial
	begin
		$readmemh("memfile.dat", RAM);
	end

	assign rd=RAM[a[31:2]]; // word aligned
	always @(posedge clk)
		if (we)
		RAM[a[31:2]] <= wd;
endmodule