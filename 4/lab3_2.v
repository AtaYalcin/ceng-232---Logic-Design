`timescale 1ns / 1ps
module lab3_2(
			input[5:0] money,
			input CLK,
			input vm, //0:VM0, 1:VM1
			input [2:0] productID, //000:sandwich, 001:chocolate, 11x: dont care
			input sugar, //0: No sugar, 1: With Sugar
			output reg [5:0] moneyLeft,
			output reg [4:0] itemLeft,
			output reg productUnavailable,//1:show warning, 0:do not show warning
			output reg insufficientFund , //1:full, 0:not full
			output reg notExactFund , //1:full, 0:not full
			output reg invalidProduct, //1: empty, 0:not empty
			output reg sugarUnsuitable, //1: empty, 0:not empty
			output reg productReady	//1:door is open, 0:closed
	);

	// Internal State of the Module
	// (you can change this but you probably need this)
	reg [4:0] numOfSandwiches;
	reg [4:0] numOfChocolate;
	reg [4:0] numOfWaterVM0;
	reg [4:0] numOfWaterVM1;
	reg [4:0] numOfCoffee;
	reg [4:0] numOfTea;

	
	initial
	begin
		
			numOfSandwiches = 5'd10;
			numOfChocolate =  5'd10;
			numOfWaterVM0 =   5'd5;
			numOfWaterVM1 =   5'd10;
			numOfCoffee =     5'd10;
			numOfTea =        5'd10;				
	end

/*
	always @(posedge CLK)
	begin
		case(productID)
			
			3'b000:begin//Sandwich
				if(vm)begin
				//noncompatible
					invalidProduct <= 1 ; 
				end else begin
				//compatible
					if(numOfSandwiches==5'b00000)begin 
						//product is depleted
						invalidProduct <= 0 ; 
						productUnavailable <= 1 ; 
					end else begin
						//there is product
						if(!(money ==6'd20))begin
							//money not accepted
							notExactFund <= 1 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
						end else begin
							//money accepted
							//purchase succesfull
							
							moneyLeft <= 0 ;
							numOfSandwiches <= numOfSandwiches - 5'b00001;
							itemLeft <= numOfSandwiches - 5'b00001;
							productReady <= 1 ;
							notExactFund <= 0 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
							insufficientFund  <= 0 ; 
							
							
							
						end
					end
				end
			end
			
			3'b001:begin//Chocolate
				if(vm)begin
				//noncompetible
					invalidProduct <= 1 ; 
				end else begin
				//compatible
					if(numOfChocolate==5'b00000)begin 
						//product is depleted
						invalidProduct <= 0 ; 
						productUnavailable <= 1 ; 
					end else begin
						//there is product
						if(!(money ==6'd10))begin
							//money not accepted
							notExactFund <= 1 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
						end else begin
							//money accepted
							moneyLeft <= 0 ;
							numOfSandwiches <= numOfChocolate - 5'b00001;
							itemLeft <= numOfChocolate - 5'b00001;							
							productReady <= 1 ;
							notExactFund <= 0 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
							insufficientFund  <= 0 ; 

						end
					end
				end 
			end
			
			3'b010:begin//Water
				//water is allways compatible but it has two sources
				if(vm)begin
					//water vm1
					if(numOfWaterVM1==5'b00000)begin 
						//product is depleted
						invalidProduct <= 0 ; 
						productUnavailable <= 1 ; 
					end else begin
						//there is product
						if(sugar)begin
							//adding sugar to Water(incompatible)
							invalidProduct <= 0 ; 
							productUnavailable <=0 ;
							sugarUnsuitable <= 1 ;
						end else begin
							//not adding sugar to water(compatible)
							if(money < 6'd5)begin
								//money non accepted
								invalidProduct <= 0 ; 
								productUnavailable <=0;
								sugarUnsuitable <= 0 ; 
								insufficientFund <= 1 ;
							end else begin
								//money accepted
								//purchace succesfull
								
							moneyLeft <= money - 6'd5;
							numOfWaterVM1 <= numOfWaterVM1 - 5'b00001;
							itemLeft <= numOfWaterVM1 - 5'b00001;
							productReady <= 1 ;
							notExactFund <= 0 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
							insufficientFund  <= 0 ; 

							end
						end				
					end
				end else begin
					//water vm0
					if(numOfWaterVM0==5'b00000)begin 
						//product is depleted
						invalidProduct <= 0 ; 
						productUnavailable <= 1 ; 
					end else begin
						//there is product						
						if(sugar)begin
							//adding sugar to Water(incompatible)
							invalidProduct <= 0 ; 
							productUnavailable <=0 ;
							sugarUnsuitable <= 1 ;
						end else begin
							//not adding sugar to water(compatible)
							if(!(money ==6'd5))begin
								//money not accepted
								notExactFund <= 1 ; 
								invalidProduct <= 0 ; 
								productUnavailable <= 0 ; 
								sugarUnsuitable <=0;
							end else begin
								//money accepted
							moneyLeft <= 0 ;
							numOfWaterVM0 <= numOfWaterVM0 - 5'b00001;
							itemLeft <= numOfWaterVM0 - 5'b00001;
							productReady <= 1 ;
							notExactFund <= 0 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
							insufficientFund  <= 0 ; 

								
							end
						end
						
					end
				end
				
				
			end
			
			3'b011:begin//Coffee
				if(vm)begin
				//compatible
					if(numOfCoffee==5'b00000)begin 
						//product is depleted
						invalidProduct <= 0 ; 
						productUnavailable <= 1 ; 
					end else begin
						//there is product
						if(money < 6'd12)begin
								//money non accepted
								invalidProduct <= 0 ; 
								productUnavailable <=0;
								sugarUnsuitable <= 0 ; 
								insufficientFund <= 1 ;
						end else begin
								//money accepted
							moneyLeft <= money - 6'd12;
							numOfCoffee <= numOfCoffee - 5'b00001;
							itemLeft <= numOfCoffee - 5'b00001;								
							productReady <= 1 ;
							notExactFund <= 0 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
							insufficientFund  <= 0 ; 


						end
					end
				end else begin
				//non-competible
					invalidProduct <= 1 ; 					
				end
			end
			
			3'b100:begin//tea
				if(vm)begin
					if(numOfTea==5'b00000)begin 
						//product is depleted
						invalidProduct <= 0 ; 
						productUnavailable <= 1 ; 
					end else begin
						//there is product
						if(money < 6'd8)begin
								//money non accepted
								invalidProduct <= 0 ; 
								productUnavailable <=0;
								sugarUnsuitable <= 0 ; 
								insufficientFund <= 1 ;
						end else begin
								//money accepted
								//purchase succesfull
							moneyLeft <= money - 6'd8;
							numOfTea <= numOfTea - 5'b00001;
							itemLeft <= numOfTea - 5'b00001;								
							productReady <= 1 ;
							notExactFund <= 0 ; 
							invalidProduct <= 0 ; 
							productUnavailable <= 0 ; 
							sugarUnsuitable <=0;
							insufficientFund  <= 0 ; 

						end
					end
				end else begin
				//non competible
					invalidProduct <= 1 ; 
				end
			end
			
			default:begin//invalid
					invalidProduct <= 1 ; 
			end
			
		endcase
		
	end
	*/
	
	always @(posedge CLK)begin 
		if(
			(
				(productID==3'b101) || 
				(productID==3'b110) ||
				(productID==3'b111)
			) ||
			(((productID==3'b011) || (productID==3'b100))&& !vm ) ||
			(((productID==3'b000) || (productID==3'b001))&& vm) 
		)
		begin
			moneyLeft <= money ; 
			productReady <= 1'b0;
			invalidProduct<= 1'b1 ; 
			productUnavailable<= 1'bx;
			sugarUnsuitable<=1'bx ; 
			notExactFund<=1'bx ; 
			insufficientFund<=1'bx ; 
		end else if(
		((productID==3'b000)&&(numOfSandwiches == 5'd0))||
		((productID==3'b001)&&(numOfChocolate == 5'd0))||
		((productID==3'b010)&&((vm &&(numOfWaterVM1 == 5'd0))||(!vm &&(numOfWaterVM0 == 5'd0))))||
		((productID==3'b011)&&(numOfCoffee == 5'd0))||
		((productID==3'b100)&&(numOfTea == 5'd0))
		)
		begin
			moneyLeft <= money ; 
			productReady <= 1'b0;
			invalidProduct<= 1'b0 ; 
			productUnavailable<= 1'b1;
			sugarUnsuitable<=1'bx ; 
			notExactFund<=1'bx ; 
			insufficientFund<=1'bx ; 
		end else if(
			sugar && (productID==3'b010)
		) 
		begin
			moneyLeft <= money ; 
			productReady <= 1'b0;
			invalidProduct<= 1'b0 ; 
			productUnavailable<= 1'b0;
			sugarUnsuitable<=1'b1 ; 
			notExactFund<=1'bx ; 
			insufficientFund<=1'bx ; 
		end else if(
		(!vm)&&
			(
				(
					(productID==3'b000)&&(money != 6'd20)
				)||
				(
					(productID==3'b001)&&(money != 6'd10)
				)||
				(
					(productID==3'b010)&&(money != 6'd5)
				)
			)
		)
		begin
			moneyLeft <= money ; 
			productReady <= 1'b0;
			invalidProduct<= 1'b0 ; 
			productUnavailable<= 1'b0;
			sugarUnsuitable<=1'b0 ; 
			notExactFund<=1'b1 ; 
			insufficientFund<=1'bx ; 
		end else if(
		vm &&
			(
				(
					(productID==3'b010)&&(money < 6'd5)
				)||
				(
					(productID==3'b011)&&(money < 6'd12)
				)||
				(
					(productID==3'b100)&&(money < 6'd8)
				)
			)
		)begin
			moneyLeft <= money ; 
			productReady <= 1'b0;
			invalidProduct<= 1'b0 ; 
			productUnavailable<= 1'b0;
			sugarUnsuitable<=1'b0 ; 
			notExactFund<=1'bx ; 
			insufficientFund<=1'b1 ; 
		end else begin
			productReady <= 1'b1;
			invalidProduct<= 1'b0 ; 
			productUnavailable<= 1'b0;
			sugarUnsuitable<=1'b0 ;
			

			notExactFund<=1'b0 ; 
			insufficientFund<=1'b0 ; 
			
			
			
			
			
			if(productID == 3'b000) begin 
				itemLeft <= numOfSandwiches - 5'd1 ;
				numOfSandwiches <= numOfSandwiches - 5'd1;
				moneyLeft <= money - 6'd20;
			end
			
			if(productID == 3'b001) begin 
				itemLeft <= numOfChocolate - 5'd1 ;
				numOfChocolate <= numOfChocolate - 5'd1;
				moneyLeft <= money - 6'd10;
			end

			if(productID == 3'b010) begin
				if(vm) begin	
					itemLeft <= numOfWaterVM1 - 5'd1 ;
					numOfWaterVM1 <= numOfWaterVM1 - 5'd1 ; 
				end else begin 
					itemLeft <= numOfWaterVM0 - 5'd1; 
					numOfWaterVM0 <= numOfWaterVM0 - 5'd1 ; 
				end
				moneyLeft <= money - 6'd5;
			end

			if(productID == 3'b011) begin 
				itemLeft <= numOfCoffee - 5'd1 ;
				numOfCoffee <= numOfCoffee - 5'd1;
				moneyLeft <= money - 6'd12;
			end

			if(productID == 3'b100) begin 
				itemLeft <= numOfTea - 5'd1 ;
				numOfTea <= numOfTea - 5'd1;
				moneyLeft <= money - 6'd8;
			end
	
			
		end
	end

endmodule



