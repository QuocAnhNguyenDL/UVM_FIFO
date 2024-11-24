`ifndef REFMODEL_SV
`define REFMODEL_SV

`include "uvm_macros.svh"
`include "define.sv"
import uvm_pkg::*;

class fifo_refmodel extends uvm_component;
    `uvm_component_utils(fifo_refmodel)

    uvm_analysis_export#(fifo_seqitem) dr2rm_export;
    uvm_analysis_port#(fifo_seqitem) rm2sb_port;
    fifo_seqitem exp_trans, rm_trans;
    uvm_tlm_analysis_fifo#(fifo_seqitem) rm_exp_fifo;

    int queue[$];

    function new(input string name = "fifo_refmodel", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        dr2rm_export = new("dr2rm_export", this);
        rm2sb_port = new("rm2sb", this);
        rm_exp_fifo = new("rm_exp_fifo", this);
    endfunction

    function void connect_phase(input uvm_phase phase);
        super.connect_phase(phase);
        dr2rm_export.connect(rm_exp_fifo.analysis_export);
    endfunction

    task run_phase(input uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rm_exp_fifo.get(rm_trans);
            get_expected_transaction();
            rm2sb_port.write(exp_trans);
        end
    endtask

    task get_expected_transaction();
        exp_trans = rm_trans;
        if(rm_trans.wr_en == 1 & queue.size() < `DEPTH - 1) begin
            queue.push_back(rm_trans.din);
            exp_trans.dout = 0;
        end

        if(rm_trans.rd_en == 1 & queue.size() > 0) begin
            exp_trans.dout = queue.pop_front();
        end

        if(queue.size() == `DEPTH) begin
            exp_trans.full = 1;
            exp_trans.empty = 0;
        end

        if(queue.size() == 0) begin
            exp_trans.full = 0;
            exp_trans.empty = 1;
        end
    endtask

endclass

`endif
