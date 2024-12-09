`ifndef MONITOR_SV
`define MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_interface fifo_if;
    uvm_analysis_port#(fifo_seqitem) mon2sb_port;
    fifo_seqitem act_trans;
    bit is_first;

    function new(input string name = "fifo_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "fifo_interface", fifo_if))
            `uvm_fatal("MONITOR_NO_IF", {get_full_name(), "not found interface"});
        mon2sb_port = new("mon2sb_port", this);
        act_trans = new("act_trans");
        is_first = 1;
    endfunction

    virtual task run_phase(input uvm_phase phase);
        forever begin
            collect_trans();

            if (is_first) begin
                is_first = 0; 
            end else begin
                mon2sb_port.write(act_trans);
            end
        end
    endtask

    task collect_trans();
        
        wait(fifo_if.rstn);
        
        
        @(fifo_if.rc_cb);
    
        
        act_trans.din = fifo_if.rc_cb.din;
        act_trans.wr_en = fifo_if.rc_cb.wr_en;
        act_trans.rd_en = fifo_if.rc_cb.rd_en;
        act_trans.dout = fifo_if.rc_cb.dout;
        act_trans.empty = fifo_if.rc_cb.empty;
        act_trans.full = fifo_if.rc_cb.full;
    endtask
endclass

`endif
