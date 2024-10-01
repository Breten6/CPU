module register_file
(
input clock,
input reset,
input write_enable,
input [4:0] addr_rs1,   
input [4:0] addr_rs2,   
input [4:0] addr_rd, 
input [31:0] data_rd,
output reg [31:0] data_rs1,
output reg [31:0] data_rs2
);
reg [31:0] registers [31:0];
initial begin
    registers[0] = 32'b0;
    registers[2] = `MEM_DEPTH + 32'h01000000;
end
always @(*)
begin
    data_rs1 = registers[addr_rs1];
    data_rs2 = registers[addr_rs2];
end

always @(posedge clock)
begin
    if(reset)begin
        registers[2] = `MEM_DEPTH + 32'h01000000;
    end
    else if(write_enable && addr_rd != 5'b0 )begin
        registers[addr_rd] <= data_rd[31:0];
    end
end
endmodule