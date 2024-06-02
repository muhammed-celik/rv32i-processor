module reg_file (
  input logic clk,
  //read ports
  input logic rd_en1,
  input logic rd_en2,
  input logic [4:0] rd_addr1,
  input logic [4:0] rd_addr2,
  output logic [31:0] rs1,
  output logic [31:0] rs2,
  //write port
  input logic wr_en,
  input logic [4:0] wr_addr,
  input logic [31:0] rd
);

logic we_ram;
assign we_ram = wr_en && (wr_addr != 5'd0); //x0 is hardwired to value 32'd0. Therefore, shouldn't be overwritten!

bram_true_dual_port # (
  .RAM_WIDTH(32),
  .RAM_DEPTH(32)
)
bram_true_dual_port_inst1 (
  .clk(clk),
  .wr_ena(we_ram),
  .wr_enb(1'b0),
  .rd_ena(1'b0),
  .rd_enb(rd_en1),
  .addra(wr_addr),
  .addrb(rd_addr1),
  .dina(rd),
  .dinb(32'b0),
  .douta(),
  .doutb(rs1)
);

bram_true_dual_port # (
  .RAM_WIDTH(32),
  .RAM_DEPTH(32)
)
bram_true_dual_port_inst2 (
  .clk(clk),
  .wr_ena(we_ram),
  .wr_enb(1'b0),
  .rd_ena(1'b0),
  .rd_enb(rd_en2),
  .addra(wr_addr),
  .addrb(rd_addr2),
  .dina(rd),
  .dinb(32'b0),
  .douta(),
  .doutb(rs2)
);
  
endmodule