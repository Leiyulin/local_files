module memory();
reg [7:0] my_mem [0:7];
initial
begin
        /*$readmemh("file",mem_array,start_addr,stop_addr);*/
        $readmemh("mem.list", my_mem);
        $display("0x00: %h", my_mem[0]);
        $display("0x01: %h", my_mem[3]);
        $display("end --");
end

initial begin
	$dumpfile("readmem.dump");
end

endmodule

// reg [msb:lsb] identifier [start:end]
// size of the item in the array is [msb:lsb]
// the number of items is [start:end]
//--
// [msb:lsb] is for little-endian
// [lsb:msb] is for big-endian