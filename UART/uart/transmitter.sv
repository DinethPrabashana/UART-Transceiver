module transmitter #(
    parameter CLOCKS_PER_PULSE = 16
)
(
    input logic [7:0] data_in,      // Input data to be transmitted
    input logic data_en,             // Data enable signal
    input logic clk,                 // System clock
    input logic rstn,                // Active low reset signal
    output logic tx,                 // Transmitted data output
    output logic tx_busy             // Transmission status output
);
    enum {TX_IDLE, TX_START, TX_DATA, TX_END} state; // Define transmission states
    
    logic [7:0] tx_data = 8'b0;       // Data to be transmitted
    logic [2:0] bit_counter = 3'b0;    // Bit counter to keep track of transmitted bits
    logic [$clog2(CLOCKS_PER_PULSE)-1:0] pulse_counter = 0; // Counter for clock pulses
    
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            // Reset all variables and state to initial values
            pulse_counter <= 0;
            bit_counter <= 0;
            tx_data <= 0;
            tx <= 1'b1;           // Set default value for tx signal
            state <= TX_IDLE;     // Set initial state to TX_IDLE
        end else begin 
            case (state)
                TX_IDLE: begin
                    if (~data_en) begin
                        state <= TX_START;
                        tx_data <= data_in;       // Load data to be transmitted
                        bit_counter <= 3'b0;      // Reset bit counter
                        pulse_counter <= 0;       // Reset pulse counter
                    end else tx <= 1'b1;           // Keep transmitter idle if no data to send
                end
                TX_START: begin
                    if (pulse_counter == CLOCKS_PER_PULSE-1) begin
                        state <= TX_DATA;         // Move to TX_DATA state after start bit transmission
                        pulse_counter <= 0;       // Reset pulse counter
                    end else begin
                        tx <= 1'b0;               // Start bit transmission
                        pulse_counter <= pulse_counter + 1; // Increment pulse counter
                    end
                end
                TX_DATA: begin
                    if (pulse_counter == CLOCKS_PER_PULSE-1) begin
                        pulse_counter <= 0;       // Reset pulse counter
                        if (bit_counter == 3'd7) begin
                            state <= TX_END;      // Move to TX_END state after all data bits transmitted
                        end else begin
                            bit_counter <= bit_counter + 1; // Move to the next bit
                            tx <= tx_data[bit_counter];    // Transmit the next bit
                        end
                    end else begin
                        tx <= tx_data[bit_counter];    // Transmit the current bit
                        pulse_counter <= pulse_counter + 1; // Increment pulse counter
                    end
                end
                TX_END: begin
                    if (pulse_counter == CLOCKS_PER_PULSE-1) begin
                        state <= TX_IDLE;           // Move back to TX_IDLE state after stop bit transmission
                        pulse_counter <= 0;         // Reset pulse counter
                    end else begin
                        tx <= 1'b1;                 // Transmit stop bit
                        pulse_counter <= pulse_counter + 1; // Increment pulse counter
                    end
                end
                default: state <= TX_IDLE;          // Default state transition to TX_IDLE
            endcase
        end
    end
    assign tx_busy = (state != TX_IDLE);           // Output busy signal when not in idle state
    
endmodule
