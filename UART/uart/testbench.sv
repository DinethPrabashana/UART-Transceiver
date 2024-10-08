`timescale 1ns/1ps

module testbench();

    localparam CLOCKS_PER_PULSE = 4;
    logic [3:0] data_in = 4'b0001;
    logic clk = 0;
    logic rstn = 0;
    logic enable = 1;

    logic tx_busy;
    logic ready;
    logic [3:0] data_out;
    logic [7:0] display_out;

    logic loopback;
    logic ready_clr = 1;

    // Instantiate UART module for testing
    uart #(.CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) 
            test_uart(.data_in(data_in),
                        .data_en(enable),
                        .clk(clk),
                        .tx(loopback),
                        .tx_busy(tx_busy),
                        .rx(loopback),
                        .ready(ready),
                        .ready_clr(ready_clr),
                        .led_out(data_out),
                        .display_out(display_out),
                        .rstn(rstn)
                        );
  
    // Toggle clock
    always begin
        #1 clk = ~clk;
    end
  
    // Test initialization and data transmission
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        rstn <= 1;                   // Assert reset initially
        enable <= 1'b0;              // Disable data transmission initially
        #2 rstn <= 0;                // Deassert reset
        #2 rstn <= 1;                // Assert reset again to initialize UART
        #5 enable <= 1'b1;           // Enable data transmission after initialization
    end
      
    // Monitor ready signal and check received data
    always @(posedge ready) begin
        if (data_out != data_in) begin
            $display("FAIL: rx data %x does not match tx %x", data_out, data_in);
            $finish();
        end else begin
            if (data_out == 4'b1111) begin // Check if received data is 11111111
                $display("SUCCESS: all bytes verified");
                $finish();
            end
            #10 rstn <= 0;               // Assert reset for next data transmission
            #2 rstn <= 1;                // Deassert reset
            data_in <= data_in + 1'b1;   // Increment data for next transmission
            enable <= 1'b0;              // Disable data transmission temporarily
            #2 enable <= 1'b1;           // Enable data transmission for the next round
        end
    end
endmodule
