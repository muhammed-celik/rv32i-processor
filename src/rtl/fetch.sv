module fetch (
  input logic clk,
  input logic rstn,
  input logic [31:0] pc_in,
  input logic stall,
  //instruction cache interface
  output logic read_enb,
  output logic [31:0] read_addr,
  input logic [31:0] inst_in,
  //fetch block control signals
  output logic fetch_ready,
  //decode block interface
  input logic decode_ready,
  output logic [31:0] pc_out,
  output logic [31:0] inst_out
);

logic [31:0] inst_addr;
assign inst_addr = pc_in >> 2; //shift pc to address instruction cache 

always_ff @(posedge clk) begin
  if(!rstn) begin
    read_enb <= 1'b0;
    read_addr <= 32'd0;
    inst_out <= 32'b0;
    fetch_ready <= 1'b1;
    pc_out <= 32'd0;
  end else begin
    if(!stall) begin
      if(decode_ready) begin
        read_enb <= 1'b1;
        read_addr <= inst_addr;
        inst_out <= inst_in;
        pc_out <= pc_in + 4;
      end else begin
        fetch_ready <= 1'b0;
      end
    end
  end
end
  
endmodule