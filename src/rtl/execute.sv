module execute (
  input logic clk,
  input logic rstn,
  //decode block interface
  input logic [31:0] op1,
  input logic [31:0] op2,
  output logic execute_ready,
  //memory block interface
  output logic [31:0] result,
  input logic memory_ready,
);
  
endmodule