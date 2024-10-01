module pd(
  input clock,
  input reset
);
//reg for the fetch (imemory)
reg        e_br_token;
reg[31:0] data_in;
reg[31:0] F_pc = 32'h01000000;
reg read_write;

//reg for the f/d
reg[31:0] inst_d;
reg[31:0]  D_pc = 32'h01000000;

//reg for d/x
reg [31:0] inst_x;

reg [31:0] imm_x;

reg [31:0] rs1_x;
reg [31:0] rs2_x;
reg [4:0]  rd_x;
reg[31:0] X_pc = 32'h01000000;

//reg for x/m
reg [31:0] M_pc = 32'h01000000;
reg [31:0] alu_m;
reg [31:0] rs2_m;
reg [4:0]  rd_m;
reg[31:0] inst_m;
reg       memRW_m;
reg[1:0]  WBsel_m;
reg  RegWEn_m;
reg [1:0]    mem_size_m; // 00 for byte 01 for half word 10 for word
reg          mem_sign_m;
//reg [31:0]   wb_w;
reg [31:0] W_pc = 32'h01000000;

//reg for m/w
reg [4:0]  rd_w;
reg [31:0] inst_w;
reg  RegWEn_w;
reg [31:0] M_pc_plus_4;
reg [31:0] alu_w;
reg [1:0] WBsel_w;

//---------------------------------
always @(posedge clock) begin
  if(reset)
    F_pc <= 32'h01000000;
  else if(stall == 0 )begin
    F_pc <= pc_offset;
    D_pc <= F_pc;
    inst_d <= inst_f;
  end
  else if (stall == 1) begin
    D_pc <= 32'hffffffff;
    inst_d <= 32'hffffffff;
  end

end

always @(posedge clock) begin
  //PC
  X_pc <= D_pc;
  M_pc <= X_pc;
  W_pc <= M_pc;
  M_pc_plus_4 <= M_pc+4;
  // insn

  inst_x <= inst_d;
  inst_m <= inst_x;
  inst_w <= inst_m;
  //rd
  rd_m <= rd_x;
  rd_w <= rd_m;
  //rs2
  rs2_x <= rs2_m;
  //regwen
  RegWEn_w <= RegWEn_m;
  //d/x
  rs1_x <= data_out_A;
  rs2_x <= data_out_B;
  imm_x <= imm;
  rd_x <= rd;
  //x/m
  alu_m <= alu_res;
  memRW_m <= memRW;
  RegWEn_m <= RegWEn;
  WBsel_m <= WBsel;
  mem_sign_m <= mem_sign;
  mem_size_m <= mem_size;
  alu_w <= alu_m;
  WBsel_w <= WBsel_m;
end
wire[31:0] inst_f;
wire[31:0] pc_offset;
wire [6:0]  opcode;
wire [2:0]  funct3;
wire [4:0]  rs1;
wire [4:0]  rs2;
wire [4:0]  rd;
wire [6:0]  funct7;
wire [31:0] imm;
wire [4:0]  shamt;
wire [31:0] data_out_A;
wire [31:0] data_out_B;
wire       br_eq;
wire       br_lt;
wire       br_un;
wire       pc_sel = 1'b0;
wire       a_sel;
wire       b_sel;
wire[3:0]  alu_sel;
wire       memRW;
wire[1:0]  WBsel;
wire  RegWEn;
wire [1:0]    mem_size; // 00 for byte 01 for half word 10 for word
wire          mem_sign;
wire [31:0] mux1_data_out;
wire [31:0] mux2_data_out;
wire [31:0] t_mux1_data_out;
wire [31:0] t_mux2_data_out;
wire [31:0] alu_res;
wire [31:0]   dmem_out;
//wire for m
wire [31:0] mux3_data_out;
wire [31:0] t_mux3_data_out;
//wire for stall
wire stall;
//wire for forwarding
wire[1:0]  f_a_sel;
wire[1:0]  f_b_sel;
wire  f_mem_sel;

imemory imem(.clock(clock),.data_in(0),.address(F_pc),.read_write(0),.data_out(inst_f));
mux mux_PC(.select(pc_sel),.data_in_0(F_pc+4),.data_in_1(alu_m),.data_out(pc_offset));
decoder decod0(.data_in(inst_d),.w_opcode(opcode),.w_rd(rd),.w_funct3(funct3),.w_rs1(rs1),.w_rs2(rs2),.w_funct7(funct7),.w_imm(imm),.w_shamt(shamt));
register_file reg_file(.clock(clock),.reset(reset),.write_enable(RegWEn_w),.addr_rs1(rs1),.addr_rs2(rs2),.addr_rd(rd_w),.data_rd(t_mux3_data_out),.data_rs1(data_out_A),.data_rs2(data_out_B));
branch_comp br_comp(.data_in_A(rs1_x),.data_in_B(rs2_x),.brun_sel(br_un),.br_eq(br_eq),.br_lt(br_lt));
control ctrl(.inst(inst_x),.br_eq(br_eq),.br_lt(br_lt),.w_br_un(br_un),.w_pc_sel(pc_sel),.w_a_sel(a_sel),.w_b_sel(b_sel),.w_alu_sel(alu_sel),.w_reg_w_en(RegWEn),.w_wb_sel(WBsel),.w_mem_rw(memRW),.w_mem_sign(mem_sign),.w_mem_size(mem_size));
mux mux_A(.select(a_sel),.data_in_0(rs1_x),.data_in_1(X_pc),.data_out(mux1_data_out));
mux mux_B(.select(b_sel),.data_in_0(rs2_x),.data_in_1(imm_x),.data_out(mux2_data_out));
three_mux t_mux_A(.select(f_a_sel),.data_in_0(mux1_data_out),.data_in_1(t_mux3_data_out),.data_in_2(alu_m),.data_out(t_mux1_data_out));
three_mux t_mux_B(.select(f_b_sel),.data_in_0(mux2_data_out),.data_in_1(t_mux3_data_out),.data_in_2(alu_m),.data_out(t_mux2_data_out));
alu ALU(.mux1(t_mux1_data_out),.mux2(t_mux2_data_out),.AluSel(alu_sel),.data_out(alu_res));
mux mux_dmem_dataw(.select(f_mem_sel),.data_in_0(t_mux3_data_out),.data_in_1(rs2_m),.data_out(mux3_data_out));
dmemory dmem(.clock(clock),.data_in(mux3_data_out),.address(alu_m),.is_sign(mem_sign_m),.access_size(mem_size_m),.read_write(memRW_m),.data_out(dmem_out));
three_mux t_mux_m_w(.select(WBsel_m),.data_in_0(dmem_out),.data_in_1(alu_m),.data_in_2(M_pc+4),.data_out(t_mux3_data_out));
stall kill(.clock(clock),.inst_f(inst_f),.inst_d(inst_d),.inst_m(inst_m),.inst_x(inst_x),.stall(stall));
forwarding fw(.clock(clock),.inst_x(inst_x),.inst_m(inst_m),.inst_w(inst_w),.f_sel_A(f_a_sel),.f_sel_B(f_b_sel),.f_mem_sel(f_mem_sel));


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
