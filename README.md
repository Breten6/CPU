# CPU
UWaterloo ECE320 lab, a single-cylce piplining CPU implemented by Verilog

# Design diagram

[click to see the diagram we drew for helping us design the CPU ](https://github.com/Breten6/CPU/blob/main/cpu_design.pdf)

# Project Stages

- [PD0](project/pd0/docs/README.md)
- [PD1](project/pd1/docs/README.md)
- [PD2](project/pd2/docs/README.md)
- [PD3](project/pd3/docs/README.md)
- [PD4](project/pd4/docs/README.md)
- [PD5](project/pd5/docs/README.md)


# Credits

The project structure heavily borrows the AWS EC2 FPGA HDK structure, [see here](https://github.com/aws/aws-fpga).

•	Designed a five-stage processor using Verilog, capable of handling a series of instructions, ensuring accurate instruction execution and adherence to hardware design principles. 
•	Implemented stage pipelining techniques to significantly enhance the processor's throughput, enabling the processor to fetch one instruction per clock cycle, thereby optimizing overall performance. 
•	Incorporated mechanisms for bypassing and inserting stalls to effectively handle data hazards, ensuring smooth operation of the processor and minimizing the impact of instruction dependencies.
