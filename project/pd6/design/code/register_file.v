module register_file
(
input clock,
input write_enable,
input [4:0] addr_rs1,   
input [4:0] addr_rs2,   
input [4:0] addr_rd, 
input [31:0] data_rd,
output [31:0] data_rs1,
output [31:0] data_rs2
);
reg [31:0] r_data_rs1;
reg [31:0] r_data_rs2;

assign data_rs1 = r_data_rs1;
assign data_rs2 = r_data_rs2;
integer      i ;
(* ram_style = "block" *) reg [31:0] registers [0:31];
initial begin

    for(i = 0 ; i<32;i=i+1)begin
        if(i == 2)begin
            registers[i] = `MEM_DEPTH + 32'h01000000;
        end
        else begin
        registers[i] = 32'b0;
        end
    end

end


always @(posedge clock)
begin

    if(write_enable && addr_rd != 5'b0 )begin
        registers[addr_rd] <= data_rd;
    end
    
    else begin
        r_data_rs1 <= registers[addr_rs1];
        r_data_rs2 <= registers[addr_rs2];
    end
end

endmodule