`timescale 1 ns/ 1 ps

module wait_test(
);

reg clk;
reg test;
reg a;

initial begin
  clk = 1'b1;
  #10 clk = 1'b0;
  #70 clk = 1'b1;
end

initial begin
	  #200 $stop;
end
initial begin
  a = 1'b0;
  #50 a = 1'b1;
  #100 a = 1'b0;

end

initial begin
  $dumpfile("wait.dump");
  $dumpvars;
end


initial begin
   test = 0;
end

initial begin
  wait(clk) test <= a;
end

endmodule
