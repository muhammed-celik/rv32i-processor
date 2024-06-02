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
  output logic rs1_en,
  output logic rs2_en,
  output logic [4:0] rs1_addr,
  output logic [4:0] rs2_addr,
  input logic [31:0] rs1_val,
  input logic [31:0] rs2_val,
);

//parse input instruction
logic [6:0] opcode;
assign opcode = inst_in[6:0];

logic [4:0] rd;
assign rd = inst_in[11:7];

logic [4:0] rs1;
assign rs1 = inst_in[19:15];

logic [4:0] rs2;
assign rs2 = inst_in[24:20];

logic [2:0] func3;
assign func3 = inst_in[14:12];

logic [6:0] func7;
assign func7 = inst_in[31:25];

logic [4:0] shamt;
assign shamt = inst_in[24:20];

always_comb begin
  case (opcode)
    OP_AL_LUI: begin //Load Upper Immediate Instruction
      o_invalid_opcode = 1'b0;
      o_alu_op1_type = ALU_IN_IMM;
      o_alu_op2_type = ALU_IN_NULL;
      o_alu_op_type = ALU_OP_ADD;
      o_pc_ctrl = 1'b0;
    end

    OP_AL_AUIPC:begin //Add Upper Immediate Instruction
      o_invalid_opcode = 1'b0;
      o_alu_op1_type = ALU_IN_PC_NEXT;
      o_alu_op2_type = ALU_IN_IMM;
      o_alu_op_type = ALU_OP_ADD;
      o_pc_ctrl = 1'b1;
    end

    OP_AL_JAL: begin //Jump and Link Instruction
      o_invalid_opcode = 1'b0;
      o_alu_op1_type = ALU_IN_PC_NEXT;
      o_alu_op2_type = ALU_IN_IMM;
      o_alu_op_type = ALU_OP_ADD;
      o_pc_ctrl = 1'b1;
    end

    OP_AL_JALR: begin //Jump and Link Register Instruction
      o_invalid_opcode = 1'b0;
      o_alu_op1_type = ALU_IN_PC_NEXT;
      o_alu_op2_type = ALU_IN_IMM;
      o_alu_op_type = ALU_OP_ADD;
      o_pc_ctrl = 1'b1;
    end

    OP_AL_B: begin //Branch Instruction
      o_invalid_opcode = 1'b0;
      if(i_comp_result) begin //Depending on the comparison result, execute instruction or don't
        o_alu_op1_type = ALU_IN_PC_NEXT;
        o_alu_op2_type = ALU_IN_IMM;
        o_alu_op_type = ALU_OP_ADD;
        o_pc_ctrl = 1'b1;
      end else begin
        o_alu_op1_type = ALU_IN_NULL;
        o_alu_op2_type = ALU_IN_NULL;
        o_alu_op_type = ALU_OP_ADD;
        o_pc_ctrl = 1'b0;
      end
    end

    OP_AL_R: begin //R-type register operations
      o_invalid_opcode = 1'b0;
      o_alu_op1_type = ALU_IN_REG;
      o_alu_op2_type = ALU_IN_REG;

      case (i_func3)
        3'b000: begin //ADD or SUB
          if(i_func7 == 7'b0) begin //ADD
            o_alu_op_type = ALU_OP_ADD;
          end else begin //SUB (i_func7 == 7'd32)
            o_alu_op_type = ALU_OP_SUB;
          end
        end
        3'b001: begin //SLL
          o_alu_op_type = ALU_OP_SLL;
        end
        3'b010: begin //SLT
          o_alu_op_type = ALU_OP_SLT;
        end
        3'b011: begin //SLTU
          o_alu_op_type = ALU_OP_SLTU;
        end
        3'b100: begin //XOR
          o_alu_op_type = ALU_OP_XOR;
        end
        3'b101: begin //SRL or SRA
          if(i_func7 == 7'b0) begin //SRL
            o_alu_op_type = ALU_OP_SRL;
          end else begin //SRA (i_func7 == 7'd32)
            o_alu_op_type = ALU_OP_SRA;
          end
        end
        3'b110: begin //OR
          o_alu_op_type = ALU_OP_OR;
        end
        3'b111: begin //AND
          o_alu_op_type = ALU_OP_AND;
        end
        default: begin
          o_alu_op_type = ALU_OP_INVALID;
        end
      endcase
      o_pc_ctrl = 1'b0;
    end

    OP_AL_I: begin //I-type register & immediate val operations
      o_invalid_opcode = 1'b0;
      o_alu_op1_type = ALU_IN_REG;

      if(i_func3 == 3'b001 || i_func3 == 3'b101) begin //Shift Amount Input
        o_alu_op2_type = ALU_IN_SHAMT;
      end else begin //Immediate Value
        o_alu_op2_type = ALU_IN_IMM; 
      end

      case (i_func3)
        3'b000: begin //ADD
          o_alu_op_type = ALU_OP_ADD;
        end
        3'b001: begin //SLL
          o_alu_op_type = ALU_OP_SLL;
        end
        3'b010: begin //SLT
          o_alu_op_type = ALU_OP_SLT;
        end
        3'b011: begin //SLTU
          o_alu_op_type = ALU_OP_SLTU;
        end
        3'b100: begin //XOR
          o_alu_op_type = ALU_OP_XOR;
        end
        3'b101: begin //SRL or SRA
          if(i_func7 == 7'b0) begin //SRL
            o_alu_op_type = ALU_OP_SRL;
          end else begin //SRA (i_func7 == 7'd32)
            o_alu_op_type = ALU_OP_SRA;
          end
        end
        3'b110: begin //OR
          o_alu_op_type = ALU_OP_OR;
        end
        3'b111: begin //AND
          o_alu_op_type = ALU_OP_AND;
        end
        default: begin
          o_alu_op_type = ALU_OP_INVALID;
        end
      endcase
      o_pc_ctrl = 1'b0;
    end
    default: begin
      o_invalid_opcode = 1'b1;
      o_alu_op1_type = ALU_IN_NULL;
      o_alu_op2_type = ALU_IN_NULL;
      o_alu_op_type = ALU_OP_INVALID;
      o_pc_ctrl = 1'b0;
    end 
  endcase
end

//decode immediate value according to the instruction type
logic [31:0] decoded_imm;
always_comb begin
  case (opcode)
    OP_AL_LUI, OP_AL_AUIPC:begin
      decoded_imm = { inst_in[31:12] , 12'b0 };
    end
    OP_AL_JALR, OP_AL_I:begin
      decoded_imm = { {20{inst_in[31]}} , inst_in[31:20] };
    end
    OP_AL_JAL:begin
      decoded_imm = { {11{inst_in[31]}} , inst_in[31] , inst_in[19:12] , inst_in[20] , inst_in[30:21] , 1'b0 };
    end
    OP_AL_B:begin
      decoded_imm = { {19{inst_in[31]}} , inst_in[31] , inst_in[7] , inst_in[30:25] , inst_in[11:8] , 1'b0 };
    end
    default:begin
      decoded_imm = 32'b0;
    end
  endcase
end

//route operand 1 to execute unit
always_comb begin
  case (opcode)
    ALU_IN_REG:begin
      o_alu_op = i_reg_val;
    end
    ALU_IN_IMM:begin
      o_alu_op = i_imm_val;
    end
    ALU_IN_PC:begin
      o_alu_op = i_pc_val;
    end
    ALU_IN_PC_NEXT:begin
      o_alu_op = i_pc_val + 32'd4;
    end
    ALU_IN_CSR:begin
      o_alu_op = i_csr_val;
    end
    ALU_IN_SHAMT:begin
      o_alu_op = {27'b0,i_shamt_val};
    end
    ALU_IN_NULL:begin
      o_alu_op = 32'b0;
    end
    default:begin
      o_alu_op = 32'b0;
    end
  endcase
end

//route operand 2 to execute unit
always_comb begin
  case (i_alu_op_type)
    ALU_IN_REG:begin
      o_alu_op = i_reg_val;
    end
    ALU_IN_IMM:begin
      o_alu_op = i_imm_val;
    end
    ALU_IN_PC:begin
      o_alu_op = i_pc_val;
    end
    ALU_IN_PC_NEXT:begin
      o_alu_op = i_pc_val + 32'd4;
    end
    ALU_IN_CSR:begin
      o_alu_op = i_csr_val;
    end
    ALU_IN_SHAMT:begin
      o_alu_op = {27'b0,i_shamt_val};
    end
    ALU_IN_NULL:begin
      o_alu_op = 32'b0;
    end
    default:begin
      o_alu_op = 32'b0;
    end
  endcase
end
  
endmodule