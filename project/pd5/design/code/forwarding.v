module forwarding
(
input        clock,
input [31:0] inst_x,
input [31:0] inst_m,
input [31:0] inst_w,
output reg [1:0]  f_sel_A,
output reg [1:0]  f_sel_B,
output reg        f_mem_sel
);
initial begin
    f_sel_A = 0;
    f_sel_B = 0;
    f_mem_sel = 1;
end

always@ (posedge clock)begin
    if(5'b01000 == inst_m[6:2])begin
        //mem_sel control
        //S type instruction
        if(inst_w[6:2] != 5'b11000 && inst_w[6:2] != 5'b01000 && inst_w[6:2] != 5'b11100)begin
            // check if the write back inst has rd
            if(inst_w[11:7] == inst_m[24:20])begin
                //rd of write back is equal to rs2 of memory
                f_mem_sel <=1'b0;

            end
            else
            begin
                f_mem_sel <=1'b1;
            end
        end
        else
        begin
            f_mem_sel <=1'b1;
        end
    end
    else
    begin
        f_mem_sel <=1'b1;
    end

    //rs control (rs1,rs2)
    if(inst_x[6:2] != 5'b01101 && inst_x[6:2] != 5'b00101 && inst_x[6:2] != 5'b11011 && inst_x[6:2] != 5'b11100)begin
        //check if the instrction at x state is using rs1
        if (inst_m[6:2] == 5'b01101 || inst_m[6:2] == 5'b00101 || inst_m[6:2] == 5'b00100 || inst_m[6:2] == 5'b01100 )begin
            //check if m state inst has valid alu value to write back
            if(inst_m[11:7] == inst_x[19:15])begin
                f_sel_A <= 2'b10;
            end
            else begin
                f_sel_A <= 2'b00;
            end

            if(inst_m[11:7] == inst_x[24:20])begin
                f_sel_B <= 2'b10;
            end
            else begin
                f_sel_B <= 2'b00;
            end
        end
        else if(inst_w[6:2] != 5'b11000 && inst_w[6:2] != 5'b01000 && inst_w[6:2] != 5'b11100)begin
            //check w state inst has valid write back value
            if(inst_w[11:7] == inst_x[19:15])begin
                //check if rd in wb state is same as rs1 in writeback
                f_sel_A <= 2'b01;
            end
            else begin
                f_sel_A <= 2'b00;
            end

            if(inst_w[11:7] == inst_x[24:20])begin
                //check if rd in wb state is same as rs2 in writeback
                f_sel_B <= 2'b01;
            end
            else begin
                f_sel_B <= 2'b00;
            end
        end
        else begin
            f_sel_A <= 2'b00;
            f_sel_B <= 2'b00;
        end
    end else
    begin
        f_sel_A <= 2'b00;
        f_sel_B <= 2'b00;
    end

    
end
endmodule
