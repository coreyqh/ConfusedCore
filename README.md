# ConfusedCore
The ConfusedCore project is a hardware implementation of Harvey Mudd Miniature Machine (*hmmm*), a toy example of a computer instruction set architecture that is used to teach assembly language programming to students taking the introductory computer science course at Harvey Mudd College.  

![Top Level](docs/images/confusedcore/confusedcore12.png)

### Goals
Since the *hmmm* ISA is for educational use and otherwise trivial, the main goal for this project is to excercise my ability to design computer hardware at the microarchitecure level to meet ISA specifications and other design constraints, as opposed to ever fabricating physical hardware. Secondary to this goal is to create a teaching tool to demonstrate to students how thier assebled programs are physcially executed in hardware, which can be a difficult concept to grasp. 
### Design
Major inspiration for the design comes from *Digital Design and Computer Architecture* by Harris and Harris (see /ConfusedCore/ACKNOWLEDGEMENTS.md). With that general framework, heavy modification and expansion was needed to implement all 22 unique instructions of the *hmmm* ISA. The entire design process is outlined in /ConfusedCore/docs/*
### Verification
The verification plan for the processor involves a SystemVerilog textbench module to test the design in simulation using software such as ModelSim or Questa. The testbench flashes code to instruction memory before executing and verifying the results of this test program. Further information about verification can be found in ConfusedCore/test. 
### Future Plans 
Although somewhat trivial, the ConfusedCore could be heavily optimized and fortified from its current design. Since the design relies on the user only attemping to execute valid *hmmm* code, it would be interesting to add memory address checkers to flag illegal accesses as well as implement other exceptions. Additionally, the only input and output for the core comes in the form of two 16-bit parallel ports. It would be an interesting excersize to change these to follow some sort of serial bus protocol. Similarly, these ports could be changed to GPIO pins, but since memory mapped IO doesn't meet the ISA's standard for the read and write instructions, the parallel or serial busses would likely still be required. 