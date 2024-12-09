`ifndef TOP_SV
`define TOP_SV

`include "uvm_macros.svh"
`include "test.sv"
`include "interface.sv"
import uvm_pkg::*;

module top;

    parameter cycle = 10;
    bit clk;
    bit rstn;
    
    assign #1 d_clk = clk;

    initial begin
        forever begin
            #(cycle/2) clk = ~clk; 
        end
    end

    initial begin
        rstn = 0;
        #(cycle*5) rstn = 1;
    end

    fifo_interface fifo_interface(clk, rstn);

    fifo #(.DEPTH(8), .DWIDTH(16)) dut(
        .clk(d_clk),
        .rstn(rstn),
        .din(fifo_interface.din),
        .wr_en(fifo_interface.wr_en),
        .rd_en(fifo_interface.rd_en),
        .dout(fifo_interface.dout),
        .full(fifo_interface.full),
        .empty(fifo_interface.empty)
    );

    initial begin
        clk = 0;
        uvm_config_db#(virtual fifo_interface)::set(uvm_root::get(),"*", "fifo_interface", fifo_interface);
        run_test("fifo_test");
    end

endmodule

`endif
