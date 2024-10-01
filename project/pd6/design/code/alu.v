module alu(
    input[31:0] mux1,
    input[31:0] mux2, 
    input[3:0]  AluSel,
    output [31:0] data_out
);
reg [31:0] out;
assign data_out = out;
always @(*) begin
    case(AluSel)
    4'b0000:out = $signed(mux1) + $signed(mux2);      //add
    4'b0001:out = $signed(mux1) - $signed(mux2);     //sub
    4'b0010:out = mux1 >> mux2[4:0];    //srl
    4'b0011:out = mux1 << mux2[4:0];    //sll
    4'b0100:out = mux1 ^ mux2;     //xor
    4'b0101:out = mux1 | mux2;     //or
    4'b0110:out = mux1 & mux2;     //and
    4'b0111:out = ($signed(mux1) < $signed(mux2))? 1:0;        //slt
    4'b1000:out = ($unsigned(mux1) < $unsigned(mux2))? 1:0;    //sltu
    4'b1001:out = $signed(mux1) >>> mux2[4:0];   //sra
    default: out = 32'hffffffff;
    endcase
end
endmodule