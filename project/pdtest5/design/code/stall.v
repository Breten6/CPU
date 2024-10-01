module stall
(
input        clock,
input [31:0] inst_f,
input [31:0] inst_d,
input [31:0] inst_x,
input [31:0] inst_m,
output   stall
);
reg   r_stall;
assign stall = r_stall;

initial begin
    r_stall = 0;
end
//inst 6:2      rd 11:7     rs1 19:15    rs2 24:20
always@ (posedge clock)begin

    // m conlict
    if(inst_m[6:2] == 5'b00000 && inst_f[6:2] == 5'b11000 && (inst_m[11:7] == inst_f[19:15] || inst_m[11:7] == inst_f[24:20]))begin
        //m is load, f is branch compare, m_rd is f_rs2 or f_rs1
        r_stall <= 1'b1;
    end // x conflict
    else if((inst_x[6:2] == 5'b00000 && inst_f[6:2] == 5'b11000 && (inst_x[11:7] == inst_f[19:15] || inst_x[11:7] == inst_f[24:20])))begin
        //m is load, f is branch compare, m_rd is f_rs2 or f_rs1 (in x state)
        r_stall <= 1'b1;
    end
    else if((inst_d[6:2] == 5'b00000 && inst_f[6:2] == 5'b11000 && (inst_d[11:7] == inst_f[19:15] || inst_d[11:7] == inst_f[24:20])))begin
        //m is load, f is branch compare, m_rd is f_rs2 or f_rs1 (in x state)
        r_stall <= 1'b1;
    end
    else if(inst_d[6:2] == 5'b11000 || inst_d[6:2] == 5'b11011 || inst_d[6:2] == 5'b11001)begin
        //branch compare, need to r_stall pc to wait for the result 
        r_stall <= 1'b1;
    end
    else if(inst_d[6:2] == 5'b00000 && ((inst_f[19:15] == inst_d[11:7]) || ((inst_f[24:20] == inst_d[11:7]) && (inst_f[6:2] != 5'b01000))))begin
        r_stall <= 1'b1;
    end
    else begin
        r_stall <= 1'b0;
    end
end
endmodule
