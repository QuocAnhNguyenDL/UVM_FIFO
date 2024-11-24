`ifndef INTERFACE_SV
`define INTERFACE_SV

`include "define.sv"

interface fifo_interface(input bit clk, rstn); // @suppress "Design unit name 'fifo_if' does not match file name 'interface'" // @suppress "Design unit name 'fifo_interface' does not match file name 'interface'"
    logic wr_en;
    logic rd_en;
    logic [`DWIDTH-1:0] din;
    logic [`DWIDTH-1:0] dout;
    logic full, empty;

    // clocking block for driver
    clocking dr_cb@(posedge clk);
        output wr_en;
        output rd_en;
        output din;
        input dout;
        input full;
        input empty;
    endclocking
    
    modport DRV (clocking dr_cb, input clk, rstn);

    // clocking block for monitor
    clocking rc_cb@(negedge clk);
        input wr_en;
        input rd_en;
        input din;
        input dout;
        input full;
        input empty;
    endclocking
    
    modport RCV (clocking rc_cb, input clk, rstn);

endinterface

`endif
