`ifndef SEQUENCER_SV
`define SEQUENCER_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
import uvm_pkg::*;

class fifo_sequencer extends uvm_sequencer#(fifo_seqitem);

    `uvm_component_utils(fifo_sequencer)

    function new(input string name = "fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass

`endif
