module dpll(reset,clk,signal_in,signal_out,syn);

parameter para_K=4;     //post-devider counter

parameter para_N=16;    //pre-divider counter

input reset;
input clk;
input signal_in;

output signal_out;
output syn;

reg signal_out;
reg dpout;
reg delclk;
reg addclk;
reg add_del_clkout;
reg [7:0]up_down_cnt;
reg [2:0]cnt8;
reg [8:0]cnt_N;
reg syn;
reg dpout_delay;
reg [8:0]cnt_dpout_high;
reg [8:0]cnt_dpout_low;


// pfd -> 
/******phase detector*****/
always@(signal_in or signal_out)
  begin
    dpout<=signal_in^signal_out;    //xor
  end

/******synchronization establish detector*****/
always@(posedge clk or negedge reset)
  begin
        if(!reset)    dpout_delay<='b0;
        else          dpout_delay<=dpout; //not 0
  end

always@(posedge clk or negedge reset)
  begin
      if(!reset)
          begin
            cnt_dpout_high<='b0; cnt_dpout_low<='b0;
          end
          //dpout and dpout_delay are the same
      else if(dpout)
                if(dpout_delay==0)  cnt_dpout_high<='b0;
                else
                    if(cnt_dpout_high==8'b11111111)  cnt_dpout_high<='b0;
                    else  cnt_dpout_high<=cnt_dpout_high+1;
      else if(!dpout)
                 if(dpout_delay==1)  cnt_dpout_low<='b0;
                 else
                     if(cnt_dpout_low==8'b11111111)  cnt_dpout_low<='b0;
                     else  cnt_dpout_low<=cnt_dpout_low+1;
   end
always@(posedge clk or negedge reset)
  begin
          if(!reset)  syn<='b0;
      else if((dpout&&!dpout_delay)||(!dpout&&dpout_delay))
           if(cnt_dpout_high[8:0]-cnt_dpout_low[8:0]<=4||cnt_dpout_low[8:0]-cnt_dpout_high[8:0]<=4)  syn<='b1;
           else  syn<='b0;
  end
/****up down couter with mod=K****/
always@(posedge clk or negedge reset)
begin
   if(!reset)
    begin
       delclk<='b0;
       addclk<='b0;
       up_down_cnt<='b00000000;
    end
   else
    begin
      if(!dpout)
       begin
        delclk<='b0;
        if(up_down_cnt==para_K-1)
          begin
            up_down_cnt<='b00000000;
            addclk<='b0;
          end
        else
          begin
           up_down_cnt<=up_down_cnt+1;
           addclk<='b0;
          end
      end
      else
        begin
        addclk<='b0;
                 if(up_down_cnt=='b0)
                   begin
                     up_down_cnt<=para_K-1;
                     delclk<='b0;
                   end
                  else
                   if(up_down_cnt==1)
                     begin
                       delclk<='b1;
                       up_down_cnt<=up_down_cnt-1;
                     end
                   else
                       up_down_cnt<=up_down_cnt-1;
                   end
                end
        end
/******add and delete clk*****/
always@(posedge clk or negedge reset)
begin
  if(!reset)
     begin
       cnt8<='b000;
     end
  else
     begin
      if(cnt8=='b111)
     begin
      cnt8<='b000;
   end
else
    if(addclk&&!syn)
       begin
         cnt8<=cnt8+2;
       end
    else
       if(delclk&&!syn)
          cnt8<=cnt8;
       else
          cnt8<=cnt8+1;
  end
end
always@(cnt8 or reset)
begin
if(!reset)
  add_del_clkout<='b0;
else
  add_del_clkout<=cnt8[2];
end

/******counter with mod=N******/
always@(posedge add_del_clkout or negedge reset)
begin
  if(!reset)
   begin
    cnt_N<='b0000;
    signal_out<='b0;
   end
else
   begin
     if(cnt_N==para_N-1)
       begin
         cnt_N<='b0000;
         signal_out<='b0;
   end
else
   if(cnt_N==(para_N-1)/2)
     begin
       signal_out<='b1;
       cnt_N<=cnt_N+1;
  end
else
      cnt_N<=cnt_N+1;
  end
end
endmodule