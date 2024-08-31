## Full-Duplex UART Transceiver

This project involves the design and implementation of a full-duplex UART (Universal Asynchronous Receiver/Transmitter) transceiver in Verilog. The transceiver supports standard UART features including data framing, parity checking, baud rate generation, and flow control.

### Features

- **Data Framing**: Includes start and stop bits for each data frame.
- **Parity Checking**: Supports even or odd parity checking.
- **Baud Rate Generation**: Configurable baud rate for reliable communication.
- **Flow Control**: Includes mechanisms to manage data flow.

### Design and Implementation

- **HDL**: Verilog
- **Design Tools**: Quartus Prime
- **Testing**: Rigorous functionality and timing compliance testing

### Getting Started

1. **Hardware Required**:
   - FPGA development board
   - UART-to-USB adapter or serial communication device
   - Connecting cables

2. **Software Required**:
   - Quartus Prime for synthesis and simulation
   - ModelSim or other HDL simulators for functional verification

3. **Usage**:
   - Compile the Verilog code in Quartus Prime.
   - Program the FPGA with the generated bitstream.
   - Connect the UART transceiver to a compatible serial communication device.
   - Verify the functionality through serial communication tests.

