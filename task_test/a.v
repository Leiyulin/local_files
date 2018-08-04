`timescale 1ns/1ns

module my_and (bus,busa,busb,control);
inout [3:0] bus,busa,busb;
input control;
//integer i;
genvar i;
generate for (i=0;i<=3;i=i+1) begin:tranif
    tranif1 (bus[i],busa[i],control);
    tranif0 (bus[i],busb[i],control);
end // for
endgenerate

initial begin
  $dumpfile("a.dump");
  $dumpvars;
end

endmodule
