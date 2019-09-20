module mux2 #(WIDTH = 8)
	(
		input logic [WIDTH-1:0] in0, in1,
		input logic select,
		output logic [WIDTH-1:0] out
	);
	
	
	assign out = select ? in1: in0;

endmodule