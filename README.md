##MINI DATA PROCESSOR##


It is a Mini FPGA based Data Accelrator built for data processing. It recives data over uart then processes it
and send results back to main cpu , main objective is parallelism and deterministic latency. This co-processor 
can be used for various tasks such as data filtering , signal processing, ML Accelerator etc. 

##COMPONENTS##

#ALU#
It is a combinational circuit used for arithmatic and logical operations. ALU in this project performs following
operations such as ADD, SUB, AND, OR, XOR, NOR, Shift left logical, Shift right logical, Shift right arithmatic,
Signed less than, Pass A, Pass B
This operations are used to process upcoming data in various tasks and helps to reduce load on main processor
or microcontroller

#UART
This IP consists of two blocks Transmitter and Reciver which is used to recive commands from main cpu and transfer
processed data back to main cpu. It is a asynchronous form of communication means no shared clock between transmitter
and reciver. For noise reduction reciver uses oversampling for accurate mid bit sampling to ensure communication will
have great noise tolerence.

#FIFO
yet to be implimented
