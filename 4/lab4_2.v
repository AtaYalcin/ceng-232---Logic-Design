`timescale 1ns / 1ps

module SelectionOfAvatar(
	input [1:0] mode,
	input [5:0] userID,
	input [1:0] candidate, // 00:Air 01:Fire, 10:Earth, 11: Water
	input CLK,
	output reg [1:0] ballotBoxId,
	output reg [5:0] numberOfRegisteredVoters,
	output reg [5:0] numberOfVotesWinner, // number of votes of winner
	output reg [1:0] WinnerId,
	output reg AlreadyRegistered,
	output reg AlreadyVoted,
	output reg NotRegistered,
	output reg VotingHasNotStarted,
	output reg RegistrationHasEnded
	);
	reg [7:0] counter ; 
	reg registry[63:0];
	reg voted[63:0];
	reg [5:0]result[3:0] ; 
	reg [3:0] index ;
	reg [6:0]i ; 

	initial begin
		counter = 8'd0 ; 
		numberOfRegisteredVoters = 6'd0 ; 
		numberOfVotesWinner = 6'd0;
		RegistrationHasEnded = 0 ;
		WinnerId = 2'd0;
		
		for(i=0 ; i < 64 ;i= i+1)begin 
			registry[i] = 1'b0 ; 
		end
		
		for(i=0 ; i < 64;i= i+1)begin 
			voted[i] = 1'b0 ; 
		end
		
		for(i=0 ; i < 4 ;i= i+1)begin 
			result[i] = 6'd0 ; 
		end
		
	end
	
	

	always @(posedge CLK)
	begin
			ballotBoxId = userID[5:4] ;
			index       = userID[3:0] ;
			
			if(counter > 8'd199)begin
				if(result[2'd0]>result[2'd1] && result[2'd0]>result[2'd2] && result[2'd0]>result[2'd3])begin
				//max 0
					WinnerId = 2'd0 ; 
				end else if(result[2'd1]>result[2'd0] && result[2'd1]>result[2'd2] && result[2'd1]>result[2'd3]) begin
				//max 1
					WinnerId = 2'd1 ; 
				end else if (result[2'd2]>result[2'd0] && result[2'd2]>result[2'd1] && result[2'd2]>result[2'd3]) begin
				//max 2
					WinnerId = 2'd2 ; 
				end else begin
				//max 3
					WinnerId = 2'd3 ; 
				end
				
				numberOfVotesWinner = result[WinnerId];
			end 
			else begin
				if(counter > 99)begin 
					//voting
					if(mode)begin//voting 
						if(registry[userID])begin
							if(voted[userID]) begin 
								RegistrationHasEnded = 1'b0 ;
								VotingHasNotStarted = 1'b0 ;
								AlreadyRegistered = 1'b0 ;
								AlreadyVoted = 1'b1 ; 
								NotRegistered = 1'b0 ;									
							end else begin 
								//finally able to vote
								voted[userID] = 1'b1 ; 
								RegistrationHasEnded = 1'b0 ;
								VotingHasNotStarted = 1'b0 ;
								AlreadyRegistered = 1'b0 ;
								AlreadyVoted = 1'b0 ; 
								NotRegistered = 1'b0 ;	
								result[candidate] = result[candidate] + 8'd1 ;
								
							end
						end else begin 
							RegistrationHasEnded = 1'b0 ;
							VotingHasNotStarted = 1'b0 ;
							AlreadyRegistered = 1'b0 ;
							AlreadyVoted = 1'b0 ; 
							NotRegistered = 1'b1 ;
						end
					end else begin
						RegistrationHasEnded = 1'b1 ;
						VotingHasNotStarted = 1'b0 ;
						AlreadyRegistered = 1'b0 ;
						AlreadyVoted = 1'b0 ; 
						NotRegistered = 1'b0 ; 
					end
				end else begin //register
					if(mode)begin 
						//mode 1 :
						VotingHasNotStarted = 1'b1 ;
						AlreadyRegistered = 1'b0 ;
						AlreadyVoted = 1'b0 ; 
						NotRegistered = 1'b0 ; 
					end else begin
						//mode 0 : 
						VotingHasNotStarted = 1'b0 ;  
						AlreadyRegistered = registry[userID];
						AlreadyVoted = 1'b0 ; 
						NotRegistered = 1'b0 ; 
						registry[userID] = 1'b1 ;
						if(AlreadyRegistered)begin end else begin
							numberOfRegisteredVoters = numberOfRegisteredVoters + 6'd1 ;
						end
					end					
				end
				counter = counter + 8'd1 ; 
			end	
	
	end

endmodule
