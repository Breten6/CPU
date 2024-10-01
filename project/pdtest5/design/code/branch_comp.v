module branch_comp(
    input[31:0] data_in_A,
    input[31:0] data_in_B,
    input brun_sel,
    output br_eq,
    output br_lt
);

reg w_br_eq;
reg w_br_lt;

assign br_eq = w_br_eq;
assign br_lt = w_br_lt;

always @( * ) begin
    case(brun_sel)
    1'b0:begin
        w_br_eq = ($signed(data_in_A) == $signed(data_in_B))? 1:0;
        w_br_lt = ($signed(data_in_A) < $signed(data_in_B))? 1:0;
    end
    1'b1:begin
        w_br_eq = ($unsigned(data_in_A) == $unsigned(data_in_B))? 1:0;
        w_br_lt = ($unsigned(data_in_A) < $unsigned(data_in_B))? 1:0;
    end
    endcase
end
endmodule