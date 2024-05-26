package defs;
  parameter XLEN = 32;
  parameter STACK_SIZE = 100;
  parameter RF_PNTR_WIDTH = 5;
  parameter OPCODE_WIDTH = 7;
  parameter FUNC3_WIDTH = 3;
  parameter FUNC7_WIDTH = 7;

  parameter logic [6:0] OP_AL_I = 0'b0010011;
  parameter logic [6:0] OP_AL_R = 0'b0110011;
  parameter logic [6:0] OP_AL_B = 0'b1100011;
  parameter logic [6:0] OP_AL_JAL = 0'b1101111;
  parameter logic [6:0] OP_AL_JALR = 0'b1100111;
  parameter logic [6:0] OP_AL_LUI = 0'b0110111;
  parameter logic [6:0] OP_AL_AUIPC = 0'b0010111;

  parameter ALU_OP_TYPE_WIDTH = 4;
  typedef enum logic [3:0] {ALU_OP_ADD,
                            ALU_OP_SUB,
                            ALU_OP_SLL,
                            ALU_OP_SLT,
                            ALU_OP_SLTU,
                            ALU_OP_XOR,
                            ALU_OP_SRL, 
                            ALU_OP_SRA, 
                            ALU_OP_OR, 
                            ALU_OP_AND,
                            ALU_OP_INVALID} alu_op_type;

  parameter ALU_IN_TYPE_WIDTH = 3;
  typedef enum logic [2:0] {ALU_IN_REG,
                            ALU_IN_IMM,
                            ALU_IN_PC,
                            ALU_IN_PC_NEXT,
                            ALU_IN_CSR,
                            ALU_IN_SHAMT,
                            ALU_IN_NULL} alu_in_type;
endpackage