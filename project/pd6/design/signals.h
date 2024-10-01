/* Your Code Below! Enable the following define's
 * and replace ??? with actual wires */
// ----- signals -----
// You will also need to define PC properly
`define F_PC                F_pc
`define F_INSN              inst_f

`define D_PC                D_pc
`define D_OPCODE            opcode
`define D_RD                rd
`define D_RS1               rs1
`define D_RS2               rs2
`define D_FUNCT3            funct3
`define D_FUNCT7            funct7
`define D_IMM               imm_x
`define D_SHAMT             shamt

`define R_WRITE_ENABLE      RegWEn
`define R_WRITE_DESTINATION rd
`define R_WRITE_DATA        t_mux3_data_out
`define R_READ_RS1          rs1
`define R_READ_RS2          rs2
`define R_READ_RS1_DATA     data_out_A
`define R_READ_RS2_DATA     data_out_B

`define E_PC                X_pc
`define E_ALU_RES           alu_res
`define E_BR_TAKEN          e_br_token

`define M_PC                M_pc
`define M_ADDRESS           alu_m
`define M_RW                memRW
`define M_SIZE_ENCODED      mem_size
`define M_DATA              dmem_out

`define W_PC                F_pc
`define W_ENABLE            clock
`define W_DESTINATION       rd_w
`define W_DATA              inst_f

`define IMEMORY             imem
`define DMEMORY             dmem

// ----- signals -----

// ----- design -----
`define TOP_MODULE                 pd
// ----- design -----
