module control
(
input [31:0]    inst,
input           br_eq,
input           br_lt,
output reg      br_un, //0 means not unsinged, 1 means unsigned
output reg      pc_sel,
output reg      a_sel,
output reg      b_sel,
output reg [3:0]    alu_sel,
output reg          reg_w_en,
output reg [1:0]    wb_sel,
output reg          mem_rw, //0 means read, 1 means write
output reg [1:0]    mem_size, // 00 for byte 01 for half word 10 for word
output reg          mem_sign // 1 for signed 0 for unsigned
);
localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam SRL = 4'b0010;
localparam SLL = 4'b0011;
localparam XOR = 4'b0100;
localparam OR = 4'b0101;
localparam AND = 4'b0110;
localparam SLT = 4'b0111;
localparam SLTU = 4'b1000;
localparam SRA = 4'b1001;

//{inst[30],inst[14:12],inst[6:2]}
always@ (*)begin
    case(inst[6:2]) //9bits
    5'b01101: begin
    //Utype lui
    pc_sel = 1'b0;
    reg_w_en = 1'b1;
    b_sel = 1'b1;
    alu_sel = ADD;
    wb_sel = 2'b01;
    //dc
    br_un = 1'b0;
    a_sel = 1'b0;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    end
    5'b00101:begin
    //Utype
    pc_sel = 1'b0;
    reg_w_en = 1'b1;
    b_sel = 1'b1;
    a_sel = 1'b1;
    alu_sel = ADD;
    wb_sel = 2'b01;
    //dc
    br_un = 1'b0;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    end
    5'b11011:begin
    //Jtype JAL
    pc_sel = 1'b1;
    reg_w_en = 1'b1;
    b_sel = 1'b1;
    a_sel = 1'b1;
    alu_sel = ADD;
    wb_sel = 2'b10;
    //dc
    br_un = 1'b0;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    end
    5'b11001:begin
    //Itype JALR
    pc_sel = 1'b1;
    reg_w_en = 1'b1;
    b_sel = 1'b1;
    a_sel = 1'b0;
    alu_sel = ADD;
    wb_sel = 2'b10;
    //dc
    br_un = 1'b0;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    end
    5'b11000: begin
    //Btype
    b_sel = 1'b1;
    a_sel = 1'b1;
    alu_sel = ADD;
    //dc
    mem_rw = 1'b0;
    reg_w_en = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    wb_sel = 2'b00;
        case(inst[14:12])
        3'b000:begin//beq
        br_un = 1'b0;
        pc_sel = br_eq;
        end
        3'b001:begin//bne
        br_un = 1'b0;
        pc_sel = !br_eq;
        //pc_sel
        end
        3'b100:begin//blt
        br_un = 1'b0;
        pc_sel = br_lt;
        end
        3'b101:begin//bge
        br_un = 1'b0;
        pc_sel = !br_lt;
        end
        3'b110:begin//bltu
        br_un = 1'b1;
        pc_sel = br_lt;
        end
        3'b111:begin//bgeu
        br_un = 1'b1;
        pc_sel = !br_lt;
        end
        default:begin
            br_un = 1'b0;
            pc_sel = 1'b0;
        end
        endcase
    end
    5'b00000:begin
    //Itype
    pc_sel = 1'b0;
    reg_w_en = 1'b1;
    b_sel = 1'b1;
    a_sel = 1'b0;
    alu_sel = ADD;
    wb_sel = 2'b00;
    mem_rw = 1'b0;
    //dc
    br_un = 1'b0;
        case(inst[14:12])
        3'b000:begin
            //LB
            mem_sign = 1'b1;
            mem_size = 2'b00;
        end
        3'b001:begin
            //LH
            mem_sign = 1'b1;
            mem_size = 2'b01;
        end
        3'b010:begin
            //LW
            mem_sign = 1'b1;
            mem_size = 2'b10;
        end
        3'b100:begin
            //LBU
            mem_sign = 1'b0;
            mem_size = 2'b00;
        end
        3'b101:begin
            //LHU
            mem_sign = 1'b0;
            mem_size = 2'b01;
        end
        default:begin
            mem_sign = 1'b0;
            mem_size = 2'b00;
        end
        endcase
    end
    5'b01000:begin
    //Stype
    pc_sel = 1'b0;
    reg_w_en = 1'b0;
    b_sel = 1'b1;
    a_sel = 1'b0;
    alu_sel = ADD;
    mem_rw = 1'b1;
    //dc
    wb_sel = 2'b00;
    br_un = 1'b0;
        case(inst[14:12])
        3'b000:begin
            //SB
            mem_sign = 1'b1;
            mem_size = 2'b00;
        end
        3'b001:begin
            //SH
            mem_sign = 1'b1;
            mem_size = 2'b01;
        end
        3'b010:begin
            //SW
            mem_sign = 1'b1;
            mem_size = 2'b10;
        end
        default:begin
            mem_sign = 1'b0;
            mem_size = 2'b00;
        end
        endcase
    end
    5'b00100:begin
    //Itype or Rtype
    mem_sign = 1'b0;
    mem_size = 2'b00;
        case(inst[14:12])
        3'b001:begin //SLLI
        pc_sel = 1'b0;
        reg_w_en = 1'b1;
        b_sel = 1'b1;
        a_sel = 1'b0;
        alu_sel = SLL;
        wb_sel = 2'b01;
        mem_rw = 1'b0;
        //dc
        br_un = 1'b0;
        end
        3'b101:begin
        pc_sel = 1'b0;
        reg_w_en = 1'b1;
        b_sel = 1'b1;
        a_sel = 1'b0;
        wb_sel = 2'b01;
        mem_rw = 1'b0;
        //dc
        br_un = 1'b0;
            case(inst[30])
            1'b0:alu_sel = SRL;//SRLI
            1'b1:alu_sel = SRA;//SRAI
            default: alu_sel = 4'b0000;
            endcase
        end
        default:begin
            //Itype
        pc_sel = 1'b0;
        reg_w_en = 1'b1;
        b_sel = 1'b1;
        a_sel = 1'b0;
        wb_sel = 2'b01;
        mem_rw = 1'b0;
        //dc
        br_un = 1'b0;
            case(inst[14:12])
            3'b000:alu_sel = ADD;//ADDI
            3'b010:alu_sel = SLT;//SLTI
            3'b011:alu_sel = SLTU;//SLTIU
            3'b100:alu_sel = XOR;//XORI
            3'b110:alu_sel = OR;//ORI
            3'b111:alu_sel = AND;//ANDI
            default:alu_sel = 4'b0000;
            endcase
        end
        endcase
    end
    5'b01100:begin
    //Rtype
    pc_sel = 1'b0;
    reg_w_en = 1'b1;
    b_sel = 1'b0;
    a_sel = 1'b0;
    wb_sel = 2'b01;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    //dc
    br_un = 1'b0;
        case(inst[14:12])
        3'b000:begin
            case(inst[30])
            1'b0:alu_sel = ADD; //ADD
            1'b1:alu_sel = SUB; //SUB
            default: alu_sel = 4'b0000;
            endcase
        end
        3'b001: alu_sel = SLL; //SLL
        3'b010: alu_sel = SLT; //SLT
        3'b011: alu_sel = SLTU; //SLTU
        3'b100: alu_sel = XOR; //XOR
        3'b101:begin
            case(inst[30])
            1'b0:alu_sel = SRL; //SRL
            1'b1:alu_sel = SRA; //SRA
            default: alu_sel = 4'b0000;
            endcase
        end
        3'b110: alu_sel = OR; //OR
        3'b111: alu_sel = AND; //AND
        default: alu_sel = 4'b0000;
        endcase
    end 
    5'b11100:begin
    //ECALL
    //$finish;
    pc_sel = 1'b0;
    reg_w_en = 1'b0;
    b_sel = 1'b0;
    alu_sel = 4'b0000;
    wb_sel = 2'b00;
    br_un = 1'b0;
    a_sel = 1'b0;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    end
    default:begin
    pc_sel = 1'b0;
    reg_w_en = 1'b0;
    b_sel = 1'b0;
    alu_sel = 4'b0000;
    wb_sel = 2'b00;
    br_un = 1'b0;
    a_sel = 1'b0;
    mem_rw = 1'b0;
    mem_sign = 1'b0;
    mem_size = 2'b00;
    end
    endcase
    end
endmodule