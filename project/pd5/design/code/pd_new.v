module pd(
  input clock,
  input reset
);
//reg for the fetch (imemory)
reg[31:0] data_in;
reg[31:0] F_pc = 32'h01000000;
reg read_write;
reg[31:0] inst_d;
//reg for the f/d
reg[31:0]  D_pc = 32'h01000000;
//--------------------------------
//reg for the decoder
reg [6:0]  opcode;

reg [2:0]  funct3;
reg [4:0]  rs1;
reg [4:0]  rs2;
reg [6:0]  funct7;

reg [4:0]  shamt;
//reg for d/x
reg [31:0] inst_x;
reg [31:0] imm_x;
reg [31:0] rs1_x;
reg [31:0] rs2_x;
reg [4:0]  rd_x;
reg[31:0] X_pc = 32'h01000000;
//reg for excute

reg       br_eq;
reg       br_lt;
reg       br_un;
reg       pc_sel;
reg       a_sel;
reg       b_sel;
reg[3:0]  alu_sel;
reg[1:0]  f_a_sel;
reg[1:0]  f_b_sel;


reg        e_br_token;
reg [31:0] mux1_data_out;
reg [31:0] mux2_data_out;
reg [31:0] pc_offset;
reg [1:0]    mem_size; // 00 for byte 01 for half word 10 for word
reg          mem_sign;
//reg for x/m
reg [31:0] M_pc = 32'h01000000;
reg [31:0] alu_m;
reg [31:0] rs2_m;
reg [4:0]  rd_m;
reg[31:0] inst_m;
reg       memRW_m;
reg[1:0]  WBsel_m;
reg  RegWEn_m;
//reg for dmemory
reg [31:0]   dmem_out;
//reg for m
reg [31:0]   wb_w;
reg [31:0] W_pc = 32'h01000000;
//reg for m/w
reg [4:0]  rd_w;
reg [31:0] inst_w;
reg  RegWEn_w;


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

mux mux_PC(.select(pc_sel),.data_in_0(F_pc+4),.data_in_1(alu_m),.data_out(F_pc));
imemory imem(.clock(clock),.data_in(data_in),.address(F_pc),.read_write(0),.data_out(inst_d));
decoder decod0(.data_in(inst_d),.opcode(opcode),.rd(rd_x),.funct3(funct3),.rs1(rs1),.rs2(rs2),.funct7(funct7),.imm(imm_x),.shamt(shamt));
register_file reg_file(.clock(clock),.reset(reset),.write_enable(RegWEn_m),.addr_rs1(rs1),.addr_rs2(rs2),.addr_rd(rd_w),.data_rd(wb_w),.data_rs1(rs1_x),.data_rs2(rs2_x));
branch_comp br_comp(.data_in_A(rs1_x),.data_in_B(rs2_x),.brun_sel(br_un),.br_eq(br_eq),.br_lt(br_lt));
control ctrl(.inst(inst_x),.br_eq(br_eq),.br_lt(br_lt),.br_un(br_un),.pc_sel(pc_sel),.a_sel(a_sel),.b_sel(b_sel),.alu_sel(alu_sel),.reg_w_en(RegWEn_m),.wb_sel(WBsel_m),.mem_rw(memRW_m),.mem_sign(mem_sign),.mem_size(mem_size));
mux mux_A(.select(a_sel),.data_in_0(rs1_x),.data_in_1(X_pc),.data_out(mux1_data_out));
mux mux_B(.select(b_sel),.data_in_0(rs2_x),.data_in_1(imm_x),.data_out(mux2_data_out));  
three_mux t_mux_A(.select(f_a_sel),.data_in_0(mux1_data_out),.data_in_1(wb_w),.data_in_2(alu_m));
three_mux t_mux_B(.select(f_b_sel),.data_in_0(mux2_data_out),.data_in_1(wb_w),.data_in_2(alu_m));
dmemory dmem(.clock(clock),.data_in(rs2_m),.address(alu_m),.access_size(mem_size),.is_sign(mem_sign),.read_write(memRW_m),.data_out(dmem_out));
three_mux t_mux_pc(.select(WBsel_m),.data_in_0(dmem_out),.data_in_1(alu_m),.data_in_2(M_pc+4));
stall kill(.clock(clock),.inst_f(inst_f),.inst_d(inst_d),.inst_m(inst_m),.inst_x(inst_x));
forwarding fw(.clock(clock),.inst_x(inst_x),.inst_m(inst_m),.inst_w(inst_w),.f_sel_A(f_a_sel),.f_sel_B(f_b_sel),.mem_sel);


// imemory imem(.clock(clock),.data_in(data_in),.address(address),.read_write(0),.data_out(data_out));
// decoder decod0(.data_in(data_out),.opcode(opcode),.rd(rd),.funct3(funct3),.rs1(rs1),.rs2(rs2),.funct7(funct7),.imm(imm),.shamt(shamt));
// control ctrl(.inst(data_out),.br_eq(br_eq),.br_lt(br_lt),.br_un(br_un),.pc_sel(pc_sel),.a_sel(a_sel),.b_sel(b_sel),.alu_sel(alu_sel),.reg_w_en(write_enable),.wb_sel(wb_sel),.mem_rw(mem_rw),.mem_sign(mem_sign),.mem_size(mem_size));
// register_file reg_file(.clock(clock),.reset(reset),.write_enable(write_enable),.addr_rs1(rs1),.addr_rs2(rs2),.addr_rd(rd),.data_rd(wb),.data_rs1(data_rs1),.data_rs2(data_rs2));
// mux mux_A(.select(a_sel),.data_in_0(data_rs1),.data_in_1(address),.data_out(mux1_data_out));
// mux mux_B(.select(b_sel),.data_in_0(data_rs2),.data_in_1(imm),.data_out(mux2_data_out));  
// mux mux_PC(.select(pc_sel),.data_in_0(address+4),.data_in_1(e_alu_res),.data_out(pc_offset));
// alu ALU(.mux1(mux1_data_out),.mux2(mux2_data_out),.AluSel(alu_sel),.data_out(e_alu_res));
// branch_comp br_comp(.data_in_A(data_rs1),.data_in_B(data_rs2),.brun_sel(br_un),.br_eq(br_eq),.br_lt(br_lt));
// dmemory dmem(.clock(clock),.data_in(data_rs2),.address(e_alu_res),.access_size(mem_size),.is_sign(mem_sign),.read_write(mem_rw),.data_out(dmem_out));
// three_mux th_mux(.select(wb_sel),.data_in_0(dmem_out),.data_in_1(e_alu_res),.data_in_2(address+4),.data_out(wb));
endmodule
