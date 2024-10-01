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
//reg for excute
reg[31:0] E_pc = 32'h01000000;


reg       br_eq;
reg       br_lt;
reg       br_un;
reg       pc_sel;
reg       a_sel;
reg       b_sel;
reg[3:0]  alu_sel;
reg       mem_rw;
reg[1:0]  wb_sel;
reg write_enable;
reg [31:0] data_rs1;
reg [31:0] data_rs2;
reg [31:0] e_alu_res;
reg        e_br_token;
reg [31:0] mux1_data_out;
reg [31:0] mux2_data_out;
reg [31:0] pc_offset;
reg [1:0]    mem_size; // 00 for byte 01 for half word 10 for word
reg          mem_sign;
//reg for dmemory
reg [31:0]   dmem_out;
reg [31:0] M_pc = 32'h01000000;
//reg for W
reg [31:0]   wb;
reg [31:0] W_pc = 32'h01000000;
//---------------------------------
always @(posedge clock) begin
  if(reset)
    address <= 32'h01000000;
  else
    address <= pc_offset;
end

always @(*)begin
  D_pc = address;
  E_pc = address;
  M_pc = address;
  W_pc = address;//why
  e_br_token = pc_sel;
end

imemory imem(.clock(clock),.data_in(data_in),.address(address),.read_write(0),.data_out(data_out));
decoder decod0(.data_in(data_out),.opcode(opcode),.rd(rd),.funct3(funct3),.rs1(rs1),.rs2(rs2),.funct7(funct7),.imm(imm),.shamt(shamt));
control ctrl(.inst(data_out),.br_eq(br_eq),.br_lt(br_lt),.br_un(br_un),.pc_sel(pc_sel),.a_sel(a_sel),.b_sel(b_sel),.alu_sel(alu_sel),.reg_w_en(write_enable),.wb_sel(wb_sel),.mem_rw(mem_rw),.mem_sign(mem_sign),.mem_size(mem_size));
register_file reg_file(.clock(clock),.reset(reset),.write_enable(write_enable),.addr_rs1(rs1),.addr_rs2(rs2),.addr_rd(rd),.data_rd(wb),.data_rs1(data_rs1),.data_rs2(data_rs2));
mux mux_A(.select(a_sel),.data_in_0(data_rs1),.data_in_1(address),.data_out(mux1_data_out));
mux mux_B(.select(b_sel),.data_in_0(data_rs2),.data_in_1(imm),.data_out(mux2_data_out));  
mux mux_PC(.select(pc_sel),.data_in_0(address+4),.data_in_1(e_alu_res),.data_out(pc_offset));
alu ALU(.mux1(mux1_data_out),.mux2(mux2_data_out),.AluSel(alu_sel),.data_out(e_alu_res));
branch_comp br_comp(.data_in_A(data_rs1),.data_in_B(data_rs2),.brun_sel(br_un),.br_eq(br_eq),.br_lt(br_lt));
dmemory dmem(.clock(clock),.data_in(data_rs2),.address(e_alu_res),.access_size(mem_size),.is_sign(mem_sign),.read_write(mem_rw),.data_out(dmem_out));
three_mux th_mux(.select(wb_sel),.data_in_0(dmem_out),.data_in_1(e_alu_res),.data_in_2(address+4),.data_out(wb));
endmodule
