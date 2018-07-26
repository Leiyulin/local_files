`timescale 1 ns/ 1 ps

module wait_test(
);

reg clk;
reg test;
reg a;

initial begin
  clk = 1'b1;
end

initial begin
	  #200 $stop;
end
initial begin
  a = 1'b1;
  #50 a = 1'b0;
  #100 a = 1'b1;

end

initial begin
  $dumpfile("wait.dump");
  $dumpvars;
end


initial begin
  test = 0;
end

always begin
   test = a;
end

endmodule
