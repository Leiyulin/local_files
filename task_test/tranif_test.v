module tranif_t(
  inout [2:0] busin,
  inout [2:0] out,
  input wire control
);

tranif1 (busin[2],out[1],control);
tranif0 (busin[1],out[0],control);
function [31:0] cal;
  input [3:0] inp;
  begin
    cal = 1;
    while(inp >= 1)
    begin
      cal = cal*inp;
      inp = inp -1;
    end
  end
endfunction


endmodule
