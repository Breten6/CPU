module pd(
  input clock,
  input reset
);

reg[31:0] data_in;
reg[31:0] address;
reg read_write;
reg[31:0] data_out;
always @(posedge clock) begin
  if(reset)
    address <= 32'h01000000;
  else
    address <= address+4;
end
 imemory imem(.clock(clock),.data_in(data_in),.address(address),.read_write(read_write),.data_out(data_out));
endmodule
