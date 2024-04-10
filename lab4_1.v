`timescale 1ns / 1ps

module ROM (
input [2:0] addr,
output reg [7:0] dataOut);

	
	always @(addr) begin 
		case(addr)
		3'd0 : dataOut = 8'b00000000;
		3'd1 : dataOut = 8'b01010101;
		3'd2 : dataOut = 8'b10101010;
		3'd3 : dataOut = 8'b00110011;
		3'd4 : dataOut = 8'b11001100;
		3'd5 : dataOut = 8'b00001111;
		3'd6 : dataOut = 8'b11110000;
		3'd7 : dataOut = 8'b11111111;
		endcase
	end

endmodule

module Difference_RAM (
input mode,
input [2:0] addr,
input [7:0] dataIn,
input [7:0] mask,
input CLK,
output reg [7:0] dataOut);
	
	// write your XOR_RAM code here
	reg [7:0] memory [7:0];
	
	initial begin
		dataOut = 8'd0 ;
		
		memory[3'd0] = 8'd0 ;
		memory[3'd1] = 8'd0 ;
		memory[3'd2] = 8'd0 ;
		memory[3'd3] = 8'd0 ;
		memory[3'd4] = 8'd0 ;
		memory[3'd5] = 8'd0 ;
		memory[3'd6] = 8'd0 ;
		memory[3'd7] = 8'd0 ;
		
	end
	
	always @(posedge CLK, posedge mode)begin 
		if(mode)begin//read operation
			dataOut = memory[addr];
		end else begin// write operation
			if(dataIn < mask) begin 
				memory[addr] = mask-dataIn ; 
			end else begin 
				memory[addr] = dataIn-mask ; 
			end
		end
	end

endmodule


module EncodedMemory (
input mode,
input [2:0] index,
input [7:0] number,
input CLK,
output [7:0] result);

	wire [7:0] mask;

	ROM R(index, mask);
	Difference_RAM DR(mode, index, number, mask, CLK, result);

endmodule


