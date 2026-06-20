`timescale 1ns / 1ps
module traffic_light_controller_tb();
reg clk, reset;
    wire east_red, east_green, east_yellow ;
    wire west_red, west_green, west_yellow;
    wire north_red, north_green, north_yellow;
    wire south_red, south_green, south_yellow;
    traffic_light_controller dut(
        .clk(clk),
        .reset(reset),
        .east_red(east_red),
        .east_yellow(east_yellow),
        .east_green(east_green),
        .west_red(west_red),
        .west_yellow(west_yellow),
        .west_green(west_green),
        .north_red(north_red),
        .north_yellow(north_yellow),
        .north_green(north_green),
        .south_red(south_red),
        .south_yellow(south_yellow),
        .south_green(south_green)
    );
    always #5 clk = ~clk;
     initial  begin
        clk =0; reset = 1;
         #20; reset = 0;
          #500;
        $stop; 
        end
endmodule
