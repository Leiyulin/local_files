`timescale 1 ns/ 1 ps

module wait_test(
);

reg clk;
reg test;

initial begin
  clk = 1'b0;
  forever #20 clk = ~clk;
end

initial begin
  $dumpfile("wait.dump");
  $dumpvars;
end

initial begin
  #200 $stop;
end

initial begin
  test = 0;
end

always @(posedge clk) begin
  wait(clk) test = ~test;
end

endmodule
