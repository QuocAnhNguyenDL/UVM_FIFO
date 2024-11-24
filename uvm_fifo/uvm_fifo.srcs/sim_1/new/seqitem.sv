`ifndef SEQITEM_SV
`define SEQITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_seqitem extends uvm_sequence_item;
    rand bit wr_en, rd_en;
    rand bit [8-1 :0 ] din;
    bit [8-1:0] dout;
    bit empty, full;

    rand int unsigned chance;


    `uvm_object_utils_begin(fifo_seqitem)
        `uvm_field_int(din, UVM_ALL_ON)
        `uvm_field_int(rd_en, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(dout, UVM_ALL_ON)
        `uvm_field_int(empty, UVM_ALL_ON)
        `uvm_field_int(full, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(input string name = "fifo_seqitem");
        super.new(name);
    endfunction

    constraint c_wren { wr_en inside {0,1}; }
    constraint c_rden { rd_en inside {0,1}; }
    constraint c_din {din inside {[0: 100]}; }

endclass


`endif
