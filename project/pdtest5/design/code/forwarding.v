module forwarding
(
input        clock,
input [31:0] inst_x,
input [31:0] inst_m,
input [31:0] inst_w,
output  [1:0]  f_sel_A,
output  [1:0]  f_sel_B,
output         f_mem_sel
);

reg [1:0]  r_f_sel_A;
reg [1:0]  r_f_sel_B;
reg        r_f_mem_sel;

assign f_sel_A = r_f_sel_A;
assign f_sel_B = r_f_sel_B;
assign f_mem_sel = r_f_mem_sel;


initial begin
    r_f_sel_A = 0;
    r_f_sel_B = 0;
    r_f_mem_sel = 1;
end

always@ (posedge clock)begin
    if(5'b01000 == inst_m[6:2])begin
        //mem_sel control
        //S type instruction
        if(inst_w[6:2] != 5'b11000 && inst_w[6:2] != 5'b01000 && inst_w[6:2] != 5'b11100)begin
            // check if the write back inst has rd
            if(inst_w[11:7] == inst_m[24:20])begin
                //rd of write back is equal to rs2 of memory
                r_f_mem_sel <=1'b0;

            end
            else
            begin
                r_f_mem_sel <=1'b1;
            end
        end
        else
        begin
            r_f_mem_sel <=1'b1;
        end
    end
    else
    begin
        r_f_mem_sel <=1'b1;
    end

    //rs control (rs1,rs2)
    if(inst_x[6:2] != 5'b01101 && inst_x[6:2] != 5'b00101 && inst_x[6:2] != 5'b11011 && inst_x[6:2] != 5'b11100)begin
        //check if the instrction at x state is using rs1
        if (inst_m[6:2] == 5'b01101 || inst_m[6:2] == 5'b00101 || inst_m[6:2] == 5'b00100 || inst_m[6:2] == 5'b01100 )begin
            //check if m state inst has valid alu value to write back
            if(inst_m[11:7] == inst_x[19:15])begin
                r_f_sel_A <= 2'b10;
            end
            else begin
                r_f_sel_A <= 2'b00;
            end

            if(inst_m[11:7] == inst_x[24:20])begin
                r_f_sel_B <= 2'b10;
            end
            else begin
                r_f_sel_B <= 2'b00;
            end
        end
        else if(inst_w[6:2] != 5'b11000 && inst_w[6:2] != 5'b01000 && inst_w[6:2] != 5'b11100)begin
            //check w state inst has valid write back value
            if(inst_w[11:7] == inst_x[19:15])begin
                //check if rd in wb state is same as rs1 in writeback
                r_f_sel_A <= 2'b01;
            end
            else begin
                r_f_sel_A <= 2'b00;
            end

            if(inst_w[11:7] == inst_x[24:20])begin
                //check if rd in wb state is same as rs2 in writeback
                r_f_sel_B <= 2'b01;
            end
            else begin
                r_f_sel_B <= 2'b00;
            end
        end
        else begin
            r_f_sel_A <= 2'b00;
            r_f_sel_B <= 2'b00;
        end
    end else
    begin
        r_f_sel_A <= 2'b00;
        r_f_sel_B <= 2'b00;
    end

    
end
endmodule
