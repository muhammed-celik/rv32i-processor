# rv32i-processor
RISC-V 32I Based 5-stage Pipelined General Purpose Processor Implementation

Instruction Fetch (IF)
- Instruction is fetched from memory (RAM) according to the PC value
- PC+4 is generated right away. However, there could be a seperate module that determines next PC (jump,branch etc. may be present)
- Estimated 1 clock cycle latency

Instruction Decode (ID)
- Instruction is decoded, type of the instruction is determined, registers that will be required are fetched from register file.
- At the same time, whether the instruction should be executed or not is determined. If there is hazard, IF and ID stages stall one clock cycle.
- If decoded instruction is branch or jump the target address is computer in parallel with reading register file. If the branch or jump is executed at the EX stage, the target address is assigned to the PC.
- Estimated 1 clock latency

Execute (EX)
- Involves ALU, multiplier, divider etc. computation circuit.
- Latency Differs According to the operation

Memory Access (MEM)
- If data is needed from memory (Load, Store instructions etc.) it is transferred in this stage.
- Estimated latency 1 clock. (Maybe 2 clocks for reading)

Writeback (WB)
- Result is written to destination register in this stage
