module mux
(  
input select,
input [31:0] data_in_0,   
input [31:0] data_in_1, 
output reg [31:0] data_out
);
always @( * ) begin
    case(select)
    1'b0:begin
        data_out = data_in_0;
    end
    1'b1:begin
        data_out = data_in_1;
    end
    endcase
end
endmodule