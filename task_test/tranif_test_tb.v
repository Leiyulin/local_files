module tranif_tb(
);
reg in;
reg out;
reg control;

initial begin
  in = 0;
  #5 in = 1;
  #10 in = 0;
  #25 in = 1;
end

initial begin
  control = 0;
  #6 control = 1;
  #16 control = 0;
  #22 control = 1;
end

initial begin
  $dumpfile("task_t.dump");
  $dumpvars;
end

tranif_t tranif_t0(in,out,control);

endmodule
