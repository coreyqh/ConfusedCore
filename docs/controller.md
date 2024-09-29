# The ConfusedCore Controller  

The ConfusedCore datapath is designed to have single cycle latency for almost all instructions, requiring multicycle latency for a small subset of the instruction set. As such, both combinational and sequential logic are required in the control circuitry. The majority of the signals can be handles by a large combinational decoder, which takes the ***Op*** and ***FuncID*** fields from the fetched instruction as well as the ***Comp*** signal from the datapath. For multicycle instructions, a state machine is used to manage control signals while the instructions are in flight.  
Now, since we know the major submodules for the controller, and which parts of the datapath are governed by each, we can create a block diagram for the controller for us to fill in later.  

*Block diagram goes here*

## Combinational Signals  

For combinational logic, it's usually best to start with a truth table. However, we must first define each of the control signals.  


| **PCSrc**     | |
| :-:           | :-      
| 00            | Increment PC
| 01            | Set PC to Immediate
| 10            | Set PC to ***RD2***

| **A2Src**     | |
| :-:           | :-    
| 0             | Address 2 comes from ***Instr*** $_{11:8}$
| 1             | Address 2 comes from ***Instr*** $_{3:0}$

| **A3Src**     | |
| :-:           | :-    
| 0             | Address 3 comes from ***Instr*** $_{11:8}$
| 1             | Address 3 comes from ***Instr*** $_{7:4}$

| **ExtType**   | |
| :-:           | :-    
| 0             | Zero extension
| 1             | Sign extension

| **RFWrite**   | |
| :-:           | :-    
| 0             | Writing to registers disabled
| 1             | Writing to registers enabled

| **ALUSrc1**   | |
| :-:           | :-    
| 0             | First ALU argument comes from ***RD1***
| 1             | First ALU argument comes from ***ExtImm***

| **ALUSrc2**   | |
| :-:           | :-    
| 0             | Second ALU argument comes from ***RD2***
| 1             | Second ALU argument is set to 16'h0001

| **OpCtrl**    | |
| :-:           | :-    
| x0            | ALU does addition
| x1            | ALU does subtraction
| 10            | div block computes div/mod and selects division
| 11            | div block computes div/mod and selects modulo

| **AdrSrc**    | |
| :-:           | :-    
| 0             | DMEM dddress comes from ALUArg1
| 1             | DMEM address comes from ALUOut

| **DMWrite**   | |
| :-:           | :-    
| 0             | Writing to data memory disabled
| 1             | Writing to data memory enabled

| **ResultSrc** | |
| :-:           | :-    
| 000           | Data memory read data written back to register file
| 001           | ALU output written back to register file
| 010           | div block output written back to register file
| 011           | mul block output written back to register file
| 100           | Extended immediate written back to register file
| 101           | Zero extended ***PCPlus1*** written back to register file
| 110           | ***ParallelIn*** written back to register file


Now, we are ready to fill out the decoder block by creating and implementing a truth table. 

| **Instruction**|  Op  | FuncID | Comp   | Flash | PCSrc | A2Src | A3Src | ExtType | RFWrite | ALUSrc1 | ALUSrc2 | OpCtrl | AdrSrc | DMWrite | ResultSrc | 
|:-              |:-:   |:-:     |:-:     |:-:    |:-:    |:-:    |:-:    |:-:      |:-:      |:-:      |:-:      |:-:     |:-:     |:-:      |:-:        |
| add            | 0110 |  xxxx  |   xx   |   0   |  00   |   1   |   0   |    x    |    1    |    0    |    0    |   00   |    x   |    0    |    001    |
| sub            | 0111 |  xxxx  |   xx   |   0   |  00   |   1   |   0   |    x    |    1    |    0    |    0    |   01   |    x   |    0    |    001    |
| mul            | 1000 |  xxxx  |   xx   |   0   |  00   |   1   |   0   |    x    |    1    |    x    |    0    |   0x   |    x   |    0    |    011    |
| div            | 1001 |  xxxx  |   xx   |   0   |  00   |   1   |   0   |    x    | ~DivBusy|    x    |    0    |   10   |    x   |    0    |    010    |
| mod            | 1010 |  xxxx  |   xx   |   0   |  00   |   1   |   0   |    x    | ~DivBusy|    x    |    0    |   11   |    x   |    0    |    010    |
| setn           | 0001 |  xxxx  |   xx   |   0   |  00   |   x   |   0   |    1    |    1    |    x    |    x    |   0x   |    x   |    0    |    100    |
| addn           | 0101 |  xxxx  |   xx   |   0   |  00   |   0   |   0   |    1    |    1    |    1    |    0    |   00   |    x   |    0    |    001    |
| storen         | 0011 |  xxxx  |   xx   |   0   |  00   |   0   |   x   |    0    |    0    |    1    |    x    |   0x   |    0   |    1    |    xxx    |
| loadn          | 0010 |  xxxx  |   xx   |   0   |  00   |   x   |   0   |    0    |    1    |    1    |    x    |   0x   |    0   |    0    |    000    |
| storer         | 0100 |  0001  |   xx   |   0   |  00   |   0   |   x   |    x    |    0    |    0    |    x    |   0x   |    0   |    1    |    xxx    |
| loadr          | 0100 |  0000  |   xx   |   0   |  00   |   x   |   0   |    x    |    1    |    0    |    x    |   0x   |    0   |    0    |    000    |
| pushr          | 0100 |  0011  |   xx   |   0   |  00   |   x   |   1   |    x    |    1    |    0    |    1    |   00   |    0   |    1    |    001    |
| popr           | 0100 |  0010  |   xx   |   0   |  00   |   x   |  1→0  |    x    |    1    |    0    |    1    |   01   |   1→0  |    0    |  001→000  |
| jeqzn          | 1100 |  xxxx  |   1x   |   0   |  01   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
|                |      |        |   0x   |   0   |  00   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
| jnezn          | 1101 |  xxxx  |   0x   |   0   |  01   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
|                |      |        |   1x   |   0   |  00   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
| jgtzn          | 1110 |  xxxx  |   x1   |   0   |  01   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
|                |      |        |   x0   |   0   |  00   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
| jltzn          | 1111 |  xxxx  |   00   |   0   |  01   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
|                |      |        |1x or x1|   0   |  00   |   x   |   x   |    0    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
| jumpr          | 0000 |  0011  |   xx   |   0   |  10   |   0   |   x   |    x    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
| calln          | 1011 |  xxxx  |   xx   |   0   |  01   |   x   |   0   |    x    |    1    |    x    |    x    |   0x   |    x   |    0    |    101    |
| read           | 0000 |  0001  |   xx   |   0   |  00   |   x   |   0   |    x    |    1    |    x    |    x    |   0x   |    x   |    0    |    110    |
| write          | 0000 |  0010  |   xx   |   0   |  00   |   0   |   x   |    x    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |
| *flash*        | xxxx |  xxxx  |   xx   |   1   |  00   |   x   |   x   |    x    |    0    |    x    |    x    |   0x   |    x   |    0    |    xxx    |


### I/O FSM 

read, write, halt and FLASH