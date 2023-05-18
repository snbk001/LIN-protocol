# LIN Protocol

The Local Interconnect Network (LIN) is a single-wire, low-speed serial communication protocol used for automotive applications. It is designed to be a cost-effective alternative to other automotive communication protocols, such as CAN.

The LIN protocol is based on a master-slave architecture. There is one master node, which initiates all communication, and one or more slave nodes, which respond to requests from the master.

## LIN Frame
The LIN protocol supports two types of frames: header frames and response frames. Header frames are sent by the commander/master node to request data from a responder/slave node. Response frames are sent by slave nodes in response to request frames.

The LIN protocol can be used to transmit a variety of data types, including sensor data, actuator commands, and diagnostic information.

### LIN Header
The header in total consists of at least 13 bits for the SYNC break, 1 delimiter bit, 10 SYNC field bits (1 start bit, 8 bits for synchronization, and 1 stop bit), and 10 identifier bits (1 start bit, 6 bits for the identifier, 2 bits for parity, and 1 stop bit).

### LIN Response
The response in total consists of 10 bits for each byte of data (1 start bit, 8 bits for data, 1 stop bit), for up to 8 data bytes, and 10 bits for checksum (1 start bit, 8 bits for checksum solution, 1 stop bit).
