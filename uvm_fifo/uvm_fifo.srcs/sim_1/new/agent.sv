`ifndef AGENT_SV
`define AGENT_SV

`include "uvm_macros.svh"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
import uvm_pkg::*;


class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_sequencer s1;
    fifo_driver d1;
    fifo_monitor m1;

    function new(input string name = "fifo_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        s1 = fifo_sequencer::type_id::create("s1", this);
        d1 = fifo_driver::type_id::create("d1", this);
        m1 = fifo_monitor::type_id::create("m1", this);
    endfunction

    function void connect_phase(input uvm_phase phase);
        super.connect_phase(phase);
        d1.seq_item_port.connect(s1.seq_item_export);
    endfunction

    
endclass

`endif
