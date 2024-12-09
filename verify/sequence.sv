`ifndef SEQUENCE_SV
`define SEQUENCE_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
import uvm_pkg::*;

class fifo_sequence extends uvm_sequence#(fifo_seqitem);
    `uvm_object_utils(fifo_sequence)

    function new(input string name = "fifo_sequence");
        super.new(name);
    endfunction

    virtual task body();
        for(int i = 0 ; i < 100 ; i ++) begin
            req = fifo_seqitem::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
            get_response(rsp);
        end
    endtask

endclass
`endif
