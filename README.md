## MINI DATA PROCESSOR


It is a Mini FPGA based Data Accelrator built for data processing. It recives data over uart then processes it
and send results back to main cpu , main objective is parallelism and deterministic latency. This co-processor 
can be used for various tasks such as data filtering , signal processing, ML Accelerator etc. 

## COMPONENTS

# ALU
It is a combinational circuit used for arithmatic and logical operations. ALU in this project performs following
operations such as ADD, SUB, AND, OR etc (refer following table)

---------------------------------
|  opcode      |      operation |
|  0000        |      add       |
|  0001        |      sub       |
|  0010        |      and       |
|  0011        |      or        |
|  0100        |      xor       |
|  0101        |      nor       |
|  0110        |      sll       |
|  0111        |      srl       |
|  1000        |      sra       |
|  1001        |      slt       |
|  1010        |      pass a    |
|  1011        |      pass b    |
|  1100        |      mul       |
|  1101        |      div       |
---------------------------------
This operations are used to process upcoming data in various tasks and helps to reduce load on main processor
or microcontroller

# UART
This IP consists of two blocks Transmitter and Reciver which is used to recive commands from main cpu and transfer
processed data back to main cpu. It is a asynchronous form of communication means no shared clock between transmitter
and reciver. For noise reduction reciver uses oversampling for accurate mid bit sampling to ensure communication will
have great noise tolerence.

# FIFO
It is used as a data buffer between Uart Reciver and Alu to ensure all the data bits are
recived properly before giving it to Alu. It uses First in first out approach to suite
the operations of data processor.

# Address decoder

# Register file