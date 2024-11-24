`ifndef TEST_SV
`define TEST_SV

`include "uvm_macros.svh"
`include "enviroment.sv"
`include "sequence.sv"

import uvm_pkg::*;

class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env e1;
    fifo_sequence sequence1;

    function new(input string name = "fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        e1 = fifo_env::type_id::create("e1", this);
        sequence1 = fifo_sequence::type_id::create("sequence1");
    endfunction

    task run_phase(input uvm_phase phase);
        phase.raise_objection(this);
            sequence1.start(e1.a1.s1);
        phase.drop_objection(this);
    endtask

endclass 

`endif
