`timescale 1ns / 1ps
module traffic_light_tb;

parameter   PERIOD = 4;
parameter   COUNT_WIDTH = 5;

parameter   GLOW_RED = 10, 
            GLOW_YELLOW_1 = 10,
            GLOW_GREEN = 10,
            GLOW_YELLOW_2 = 10;

reg clk, rst_n, red, yellow, green;

wire o_red, o_yellow, o_green;

integer error_counter;

traffic_light #( 
        .GLOW_RED(GLOW_RED), 
        .GLOW_YELLOW_1(GLOW_YELLOW_1),
        .GLOW_GREEN(GLOW_GREEN),
        .GLOW_YELLOW_2(GLOW_YELLOW_2))
        
             traffic_light
              (
                .i_clk(clk),
                .i_rst_n(rst_n),
                .o_red(o_red),
                .o_yellow(o_yellow), 
                .o_green(o_green)
              );
                            
initial begin
clk = 0 ;
forever #(PERIOD/2) clk = ~clk;                    
end


initial begin
error_counter = 0;

forever 
    begin
	@(posedge clk)
	if (o_red !== red | o_yellow !== yellow | o_green !== green)
	begin
		error_counter = error_counter + 1;
		$display ("error!!!");
		$display ("o_red = %d, red = %d", o_red, red);
        	$display ("o_yellow = %d, yellow = %d", o_yellow, yellow);
        	$display ("o_green = %d, green = %d", o_green, green);
       	 	$display ("time = %d", $time());
	end
    end
end


initial begin

rst_n <= 0;
red <= 1;
green <= 0;
yellow <= 0;
repeat (5) @(posedge clk);

rst_n <= 1;
repeat(2) begin
red <= 1;
green <= 0;
yellow <= 0;
repeat (GLOW_RED) @(posedge clk);

red <= 0;
green <= 0;
yellow <= 1;
repeat (GLOW_YELLOW_1) @(posedge clk);

red <= 0;
green <= 1;
yellow <= 0;
repeat (GLOW_GREEN) @(posedge clk);

red <= 0;
green <= 0;
yellow <= 1;
repeat (GLOW_YELLOW_2) @(posedge clk);

end

if (error_counter == 0)
	$display ("Finish simulation. SUCCESFUL!");
else
	$display ("error = $d", error_counter);
$finish();
end

endmodule
