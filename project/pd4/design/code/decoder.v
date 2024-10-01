module decoder
(
input [31:0] data_in,
output reg [6:0]  opcode,
output reg [4:0]  rd,
output reg [2:0] funct3,
output reg [4:0] rs1,
output reg [4:0] rs2,
output reg [6:0] funct7,
output reg [31:0] imm,
output reg [4:0] shamt
);
initial begin
    assign opcode = data_in[6:0];
end
always@ (*)begin
    case(opcode)
    7'b0110111: begin
    //Utype
        rd = data_in[11:7];
        imm = {data_in[31:12],12'b000000000000};//here
        //not have--------------------------------------
        funct3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b0010111:begin
    //Utype
        rd = data_in[11:7];
        imm = {data_in[31:12],12'b000000000000};//here
        //not have--------------------------------------
        funct3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b1101111:begin
    //Jtype
        rd = data_in[11:7];
        imm = {{(12){data_in[31]}},data_in[19:12],data_in[20],data_in[30:21],1'b0}; 
        //not have--------------------------------------
        funct3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b1100111:begin
    //Itype
        rd = data_in[11:7];
        funct3 = data_in[14:12];
        rs1 = data_in[19:15];
        imm = {{(20){data_in[31]}}, data_in[31:20]};
        //not have--------------------------------------
        rs2 = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b1100011: begin
    //Btype
        funct3 = data_in[14:12];
        rs1 = data_in[19:15];
        rs2 = data_in[24:20];
        imm = {{(20){data_in[31]}}, data_in[7], data_in[30:25], data_in[11:8],1'b0};
        //not have--------------------------------------
        rd = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b0000011:begin
    //Itype
        rd = data_in[11:7];
        funct3 = data_in[14:12];
        rs1 = data_in[19:15];
        imm = {{(20){data_in[31]}},data_in[31:20]};
        //not have--------------------------------------
        rs2 = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b0100011:begin
    //Stype
        funct3 = data_in[14:12];
        rs1 = data_in[19:15];
        rs2 = data_in[24:20];
        imm = {{(20){data_in[31]}},data_in[31:25],data_in[11:7]};
        //not have--------------------------------------
        rd = 5'b0;
        funct7 = 7'b0;
        shamt =5'b0;
    end
    7'b0010011:begin
    //Itype or Rtype
        funct3 = data_in[14:12];
        rd = data_in[11:7];
        case(funct3)
        3'b001:begin
            //Rtype
            rs1 = data_in[19:15];
            shamt = data_in[24:20];
            funct7 = data_in[31:25];
            //not have--------------------------------------
            rs2 = 5'b0;
            imm = {{(27){data_in[24]}},data_in[24:20]};//check
        end
        3'b101:begin
            //Rtype
            rs1 = data_in[19:15];
            shamt = data_in[24:20];
            funct7 = data_in[31:25];
            //not have--------------------------------------
            rs2 = 5'b0;
            imm = {{(27){data_in[24]}},data_in[24:20]};//check
        end
        default:begin
        //Itypes
            rs1 = data_in[19:15];
            imm = {{(20){data_in[31]}},data_in[31:20]};
            //not have--------------------------------------
            rs2 = 5'b0;
            funct7 = 7'b0;
            shamt =5'b0;
        end
        endcase
    end
    7'b0110011:begin
    //Rtype
        rd = data_in[11:7];
        rs1 = data_in[19:15];
        rs2 = data_in[24:20];
        funct3 = data_in[14:12];
        funct7 = data_in[31:25];
        //not have--------------------------------------
        imm = 32'b0;
        shamt =5'b0;
    end 
    7'b1110011:begin
    //ECALL
        rd = 5'b0;
        funct3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct7 = 7'b0;
        imm = 32'b0;
        shamt =5'b0;
    end
    default:begin
        rd = 5'b0;
        funct3 = 3'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct7 = 7'b0;
        imm = 32'b0;
        shamt =5'b0;
    end
    endcase
    end
endmodule
