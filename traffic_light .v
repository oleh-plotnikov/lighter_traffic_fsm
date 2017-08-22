`timescale 1ns / 1ps

module traffic_light 
                    (
                        input 		i_clk,
                        input 		i_rst_n,
                        
			output reg 	o_red, 
			    		o_yellow,
			    		o_green
                    );

localparam RED = 0, YELLOW_2 = 1, GREEN = 2, YELLOW_1 = 3;

parameter   COUNT_WIDTH 	= 32;

parameter   GLOW_RED 		= 48, 
            GLOW_YELLOW_1 	= 12,
            GLOW_GREEN 		= 48,
            GLOW_YELLOW_2 	= 12;

reg [3:0] state, next_state;
reg       next_red, next_yellow, next_green;

reg [COUNT_WIDTH - 1:0] count;
reg         		count_rst_n;

	
	
// next state registers with counter
always @(posedge i_clk, negedge i_rst_n)
    if (!i_rst_n) begin
        
	state[RED] <= 1'b1;
        o_red <= 1'b1;
        o_yellow <= 1'b0;
        o_green <= 1'b0;
	count <= 0;
            
    end else begin
        
	state <= next_state;
        o_red <= next_red;
        o_yellow <= next_yellow;
        o_green <= next_green;
    
    if(!count_rst_n)    
	count <= 0;
    else
        count <= count + 1;  	    
            
    end

	

// next state combinational logic
always @* begin

next_state = 4'b0;
next_red = 1'b0;
next_yellow = 1'b0;
next_green = 1'b0;
count_rst_n = 1'b1;

     case (1'b1) //synopsys parallel_case full_case
        
	state[RED]:
		if (count == GLOW_RED - 1)begin
		    
                next_state[YELLOW_2] = 1'b1;
                next_yellow = 1'b1;
                count_rst_n = 1'b0;
		    
            end else begin
		    
                next_state[RED] = 1'b1;
                next_red = 1'b1;
		    
            end        
        
	     
	state[YELLOW_2]:
		if (count == GLOW_YELLOW_2 - 1) begin
		    
                next_state[GREEN] = 1'b1;
                next_green = 1'b1;
                count_rst_n = 1'b0;
		    
            end else begin
		    
                next_state[YELLOW_2] = 1'b1;
                next_yellow = 1'b1;
		    
            end        
        
	state[GREEN]:
		if (count == GLOW_GREEN - 1) begin
		    
                next_state[YELLOW_1] = 1'b1;
                next_yellow = 1'b1;
                count_rst_n = 1'b0;
		    
            end else begin
		    
                next_state[GREEN] = 1'b1;
                next_green = 1'b1;
		    
            end 
	     
        state[YELLOW_1]:
		if (count == GLOW_YELLOW_1 - 1) begin
		    
                next_state[RED] = 1'b1;
                next_red = 1'b1;
                count_rst_n = 1'b0;
		    
            end else begin
		    
                next_state[YELLOW_1] = 1'b1;
                next_yellow = 1'b1;  
		    
            end
    
     endcase
end
    
endmodule
