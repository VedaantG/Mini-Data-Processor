## MINI DATA PROCESSOR


It is a Mini FPGA based Data Accelrator built for data processing. It recives data over uart then processes it
and send results back to main cpu , main objective is parallelism and deterministic latency. This co-processor 
can be used for various tasks such as data filtering , signal processing, ML Accelerator etc. 

## COMPONENTS

# ALU
It is a combinational circuit used for arithmatic and logical operations. ALU in this project performs following
operations such as ADD, SUB, AND, OR etc (refer following table)


0000 : add<br>
0001 : sub<br> 
0010 : and<br>
0011 : or<br>
0100 : xor<br>
0101 : nor<br>
0110 : sll<br>
0111 : srl<br>
1000 : sra<br>
1001 : slt<br>
1010 : pass a<br>
1011 : pass b<br>
1100 : mul<br>
1101 : div<br>

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

# Register file