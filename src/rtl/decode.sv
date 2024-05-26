module decode (
  input logic clk,
  input logic rstn,
  input logic stall,
  //fetch block interface
  input logic [31:0] pc_in,
  input logic [31:0] inst_in,
  output logic decode_ready,
  //execute block interface
  output logic [31:0] pc_out,
  input logic execute_ready,
  //register file interface
  output logic rd_ena,
  output logic rd_enb,
  output logic [4:0] addra,
  output logic [4:0] addrb,
  input logic [31:0] rs1,
  input logic [31:0] rs2,
);
  
endmodule