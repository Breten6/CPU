module imemory
(
input clock,     
input [31:0] address,   
input [31:0] data_in,    
input read_write,    
output [31:0] data_out
);
reg [7:0] mem[0:`MEM_DEPTH-1];   
reg [31:0] memh[0:`MEM_DEPTH-1];   
integer i;
assign data_out = {mem[address-32'h01000000+3],mem[address-32'h01000000+2],
mem[address-32'h01000000+1],mem[address-32'h01000000]}; 
initial begin
    $readmemh(`MEM_PATH,memh);

    for(i=0;i<`LINE_COUNT;i=i+1)
    begin
        mem[i*4] = memh[i][7:0];
        mem[i*4+1] = memh[i][15:8];
        mem[i*4+2] = memh[i][23:16];
        mem[i*4+3] = memh[i][31:24];
    end
end
always @(posedge clock) 
begin        
   if(read_write)
            begin
                mem[address-32'h01000000] <= data_in[7:0];
                mem[address-32'h01000000+1] <= data_in[15:8];
                mem[address-32'h01000000+2] <= data_in[23:16];
                mem[address-32'h01000000+3] <= data_in[31:24];
            end   
end
endmodule