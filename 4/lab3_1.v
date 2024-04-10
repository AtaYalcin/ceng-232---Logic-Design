`timescale 1ns / 1ps


module bh(input B, input H, input clk, output reg Q);

    initial begin
        Q = 1;
    end
	 
		wire[2:0] inp ; 
		assign inp = {B,H,Q};
	 
	 always @(posedge clk)
		begin	 
		
		 case(inp)
			3'b000: Q <=1;
			3'b001: Q <=0;
			3'b010: Q <=1;
			3'b011: Q <=1;
			3'b100: Q <=0;
			3'b101: Q <=0;
			3'b110: Q <=0;
			3'b111: Q <=1;
			
			default: Q <= 1'bx;
		 
		 
		 endcase
		 
		end

	

endmodule

module ic1337(// Inputs
              input A0,
              input A1,
              input A2,
              input clk,
              // Outputs
              output Q0,
              output Q1,
              output Z);
	
	/*
	
	wire d1 ; 
	wire B1 ;
	wire HB ;
	wire d2;
	wire h2 ;
	
	
	
	xor(d1,A0,!A1);
	or(B1,d1,A2);
	and(HB,A0,!A2);
	
	nor(d2,!A0,A1);
	and(h2,A2,d2);
	
	
	bh ff1 (B1,HB,clk,Q0);
	bh ff2 (HB,h2,clk,Q1);
	
	wire l ; 
	xor(l,Q0,Q1);
	not(Z,l);
	
	*/
	
	
	assign B1 = (A0 != !A1) || A2  ;
	assign middle  = A0 & !A2 ;
	assign H2 =  (!(!A0 || A1)) & A2 ; 
	
	bh FF1(B1, middle, clk, Q0);	
	bh FF2(middle, H2, clk, Q1);

	assign Z = Q0==Q1 ;// !(Q0 != Q1)
	

endmodule
