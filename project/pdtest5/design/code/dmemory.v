module dmemory(
  input             clock,
  input [31:0]      address,
  input [31:0]      data_in,
  input             read_write,
  input             is_sign,//1 for signed, 0 for unsigned
  input [1:0]       access_size,//00 for byte, 01 for half, 10 for word
  output [31:0]      data_out
);
reg [31:0] out;
assign data_out = out;
reg [7:0] mem[0:`MEM_DEPTH-1];   
reg [31:0] memh[0:`MEM_DEPTH-1];   
integer i;
always @(access_size, is_sign)begin
    case(access_size)
    2'b00: begin
        if(is_sign == 1)begin
            out = (read_write == 0)?{{24{mem[address-32'h01000000][7]}},mem[address-32'h01000000]}:32'bx; 
        end
        else begin
            out = (read_write == 0)?{{24{1'b0}},mem[address-32'h01000000]}:32'bx; 
        end
    end
    2'b01: begin 
        if(is_sign == 1)begin
            out = (read_write == 0)?{{16{mem[address-32'h01000000+1][7]}},mem[address-32'h01000000+1],mem[address-32'h01000000]}:32'bx; 
        end
        else begin
            out = (read_write == 0)?{{16{1'b0}},mem[address-32'h01000000+1],mem[address-32'h01000000]}:32'bx; 
        end
    end
    2'b10: begin 
        out = (read_write == 0)?{mem[address-32'h01000000+3],mem[address-32'h01000000+2],mem[address-32'h01000000+1],mem[address-32'h01000000]}:32'bx; 
    end
    default:begin
        out = (read_write == 0)?{mem[address-32'h01000000+3],mem[address-32'h01000000+2],mem[address-32'h01000000+1],mem[address-32'h01000000]}:32'bx;
    end
endcase
end
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
    case(access_size)
    2'b00:begin
        mem[address-32'h01000000] <= data_in[7:0];
    end
    2'b01:begin
        mem[address-32'h01000000] <= data_in[7:0];
        mem[address-32'h01000000+1] <= data_in[15:8];
    end
    2'b10:begin
        mem[address-32'h01000000] <= data_in[7:0];
        mem[address-32'h01000000+1] <= data_in[15:8];
        mem[address-32'h01000000+2] <= data_in[23:16];
        mem[address-32'h01000000+3] <= data_in[31:24];
    end
    default:begin
        mem[address-32'h01000000] <= data_in[7:0];
    end
    endcase
    end  
end
endmodule