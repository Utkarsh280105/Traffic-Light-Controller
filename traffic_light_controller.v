`timescale 1ns / 1ps
module traffic_light_controller(
    input clk, reset,
    output reg east_red, east_green, east_yellow,   //Controls the East direction traffic lights
    output reg west_red, west_green, west_yellow,
    output reg north_red, north_green, north_yellow,
    output reg south_red,south_green, south_yellow
);
  
parameter S0_EW_GREEN   = 2'b00,   //East-West green, North-South red
          S1_EW_YELLOW  = 2'b01,
          S2_NS_GREEN   = 2'b10, 
          S3_NS_YELLOW  = 2'b11 ;
           
reg [1:0] present_state, next_state;
reg [3:0] count;  // counts clock cycles for state duration
parameter GREEN_TIME = 4'd9,   // 10 sec
          YELLOW_TIME = 4'd2;  // 3 sec

  
reg [25:0] counter;
reg clk1hz;
    
always @(posedge clk or posedge reset)
begin
   if (reset) 
       begin
            counter <= 0;
            clk1hz <= 0;
        end 
        else 
        begin
            if (counter == 26'd49_999_999) begin
                counter <= 0;
                clk1hz <= ~clk1hz;  // toggle every 0.5 sec -> 1 Hz clock
          end 
            else 
            begin
                counter <= counter + 1;
          end         
     end
end
  
  always @(posedge clk1hz or posedge reset) 
  begin
    if (reset)
     begin
        present_state <= S0_EW_GREEN;
        count <= 0;
     end 
    else begin
           if ((present_state == S0_EW_GREEN   && count == GREEN_TIME) ||  
    (present_state == S1_EW_YELLOW  && count == YELLOW_TIME) ||  
    (present_state == S2_NS_GREEN   && count == GREEN_TIME) ||  
    (present_state == S3_NS_YELLOW  && count == YELLOW_TIME))
   
        begin
            count <= 0;
            present_state <= next_state;
        end 
        else 
        begin
            count <= count + 1;
        end
    end
end

always @(*) 
begin
    case(present_state)
        S0_EW_GREEN:   next_state = S1_EW_YELLOW;
        S1_EW_YELLOW:  next_state = S2_NS_GREEN;
        S2_NS_GREEN:   next_state = S3_NS_YELLOW;
        S3_NS_YELLOW:  next_state = S0_EW_GREEN;
        default:       next_state = S0_EW_GREEN;
    endcase
end

always @(*) 
begin
    east_red = 0; east_yellow = 0; east_green = 0;
    west_red = 0; west_yellow = 0; west_green = 0;
    north_red = 0; north_yellow = 0; north_green = 0;
    south_red = 0; south_yellow = 0; south_green = 0;
    case(present_state)
        S0_EW_GREEN:
         begin
            east_green = 1;
            west_green = 1;
            north_red = 1; 
            south_red = 1;
        end
        S1_EW_YELLOW: 
        begin
            east_yellow = 1; 
            west_yellow = 1;
            north_red = 1; 
            south_red = 1;
        end
        S2_NS_GREEN: 
        begin
            north_green = 1; 
            south_green = 1;
            east_red = 1; 
            west_red = 1;
        end
        S3_NS_YELLOW: 
        begin
            north_yellow = 1; 
            south_yellow = 1;
            east_red = 1; 
            west_red = 1;
        end
    endcase
end  endmodule
