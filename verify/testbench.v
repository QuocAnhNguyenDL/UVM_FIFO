`timescale 1ns / 1ps

module fifo_tb;

    parameter DEPTH = 8;
    parameter DWIDTH = 16;

    // Inputs
    reg rstn;
    reg clk;
    reg wr_en;
    reg rd_en;
    reg [DWIDTH-1:0] din;

    // Outputs
    wire [DWIDTH-1:0] dout;
    wire empty;
    wire full;

    // Instantiate the FIFO
    fifo #(DEPTH, DWIDTH) uut (
        .rstn(rstn),
        .clk(clk),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10ns
    end

    // Test sequence
    initial begin
        // Initialize signals
        rstn = 0;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // Apply reset
        #10 rstn = 1;

        // Write data into FIFO
        $display("Writing data into FIFO...");
        repeat (DEPTH) begin
            @(posedge clk);
            wr_en = 1;
            din = $random; // Generate random data
        end
        wr_en = 0;
        din = 0;

        // Check if FIFO is full
        @(posedge clk);
        if (full) $display("FIFO is full as expected.");
        else $display("FIFO is NOT full, unexpected behavior!");

        // Read data from FIFO
        $display("Reading data from FIFO...");
        repeat (DEPTH) begin
            @(posedge clk);
            rd_en = 1;
        end
        rd_en = 0;

        // Check if FIFO is empty
        @(posedge clk);
        if (empty) $display("FIFO is empty as expected.");
        else $display("FIFO is NOT empty, unexpected behavior!");

        // End simulation
        $stop;
    end

endmodule
