module alu(
    input[31:0] mux1,
    input[31:0] mux2, 
    input[3:0]  AluSel,
    output reg[31:0] data_out
);
always @(*) begin
    case(AluSel)
    4'b0000:data_out = mux1+ mux2;      //add
    4'b0001:data_out = mux1 - mux2;     //sub
    4'b0010:data_out = mux1 >> mux2;    //srl
    4'b0011:data_out = mux1 << mux2;    //sll
    4'b0100:data_out = mux1 ^ mux2;     //xor
    4'b0101:data_out = mux1 | mux2;     //or
    4'b0110:data_out = mux1 & mux2;     //and
    4'b0111:data_out = ($signed(mux1) < $signed(mux2))? 1:0;        //slt
    4'b1000:data_out = ($unsigned(mux1) < $unsigned(mux2))? 1:0;    //sltu
    4'b1001:data_out = mux1 >>> mux2;   //sra
    default: data_out = 32'hffffffff;
    endcase
end
endmodule