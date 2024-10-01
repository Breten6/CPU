module three_mux
(  
input [1:0] select,
input [31:0] data_in_0,   
input [31:0] data_in_1, 
input [31:0] data_in_2,
output reg [31:0] data_out
);
always @( * ) begin
    case(select)
    2'b00:begin
        data_out = data_in_0;
    end
    2'b01:begin
        data_out = data_in_1;
    end
    2'b10:begin
        data_out = data_in_2;
    end
    default:begin
        data_out = data_in_0;
    end
    endcase
end
endmodule