module pd(
  input clock,
  input reset
);
//reg for the decoder
reg[31:0]  D_pc = 32'h01000000;
reg [6:0]  opcode;
reg [4:0]  rd;
reg [2:0]  funct3;
reg [4:0]  rs1;
reg [4:0]  rs2;
reg [6:0]  funct7;
reg [31:0] imm;
reg [4:0]  shamt;
//--------------------------------
//reg for the fetch (imemory)
reg[31:0] data_in;
reg[31:0] address = 32'h01000000;
reg read_write;
reg[31:0] data_out;
//---------------------------------
always @(*)begin
  D_pc = address;
end
always @(posedge clock) begin
  if(reset)
    address <= 32'h01000000;
    //D_pc <= 32'h01000000;
  else
    address <= address+4;
end
 imemory imem(.clock(clock),.data_in(data_in),.address(address),.read_write(0),.data_out(data_out));
 decoder decod0(.data_in(data_out),.opcode(opcode),.rd(rd),.funct3(funct3),.rs1(rs1),.rs2(rs2),.funct7(funct7),.imm(imm),.shamt(shamt));
endmodule
