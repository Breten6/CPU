module three_mux
(  
input [1:0] select,
input [31:0] data_in_0,   
input [31:0] data_in_1, 
input [31:0] data_in_2,
output [31:0] data_out
);

reg [31:0] r_data_out;
assign data_out = r_data_out;


always @( * ) begin
    case(select)
    2'b00:begin
        r_data_out = data_in_0;
    end
    2'b01:begin
        r_data_out = data_in_1;
    end
    2'b10:begin
        r_data_out = data_in_2;
    end
    default:begin
        r_data_out = data_in_0;
    end
    endcase
end
endmodule