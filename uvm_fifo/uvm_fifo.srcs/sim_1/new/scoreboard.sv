`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
import uvm_pkg::*;

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)
    
    uvm_analysis_export#(fifo_seqitem) rm2sb_export, mon2sb_export;
    uvm_tlm_analysis_fifo#(fifo_seqitem) rm2sb_fifo, mon2sb_fifo;
    fifo_seqitem act_trans_fifo[$], exp_trans_fifo[$];
    fifo_seqitem act_trans, exp_trans;

    function new(input string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        rm2sb_export = new("rm2sb_export", this);
        mon2sb_export = new("mon2sb_export", this);
        rm2sb_fifo = new("rm2sb_fifo", this);
        mon2sb_fifo = new("mon2sb_fifo", this);
    endfunction

    function void connect_phase(input uvm_phase phase);
        super.connect_phase(phase);
        rm2sb_export.connect(rm2sb_fifo.analysis_export);
        mon2sb_export.connect(mon2sb_fifo.analysis_export);
    endfunction

    virtual task run_phase(input uvm_phase phase);
        forever begin
            #10ns

            mon2sb_fifo.get(act_trans);
            if(act_trans == null) $stop;
            act_trans_fifo.push_back(act_trans); 
            rm2sb_fifo.get(exp_trans);
            if(exp_trans == null) $stop;
            exp_trans_fifo.push_back(exp_trans);
            
            compare_trans();
        end
    endtask

    bit error = 0;

    virtual task compare_trans();
        fifo_seqitem act_trans, exp_trans;
        if(act_trans_fifo.size() != 0) begin
            act_trans = act_trans_fifo.pop_front();
            if(exp_trans_fifo.size() != 0) begin
                exp_trans = exp_trans_fifo.pop_front();
                
                `uvm_info("SB",$sformatf("EXP_TRANS"),UVM_LOW);
                exp_trans.print();
                `uvm_info("SB",$sformatf("ACT_TRANS"),UVM_LOW);
                act_trans.print();

                if(act_trans.wr_en == 0) begin
                    if(act_trans.empty != exp_trans.empty || act_trans.full != exp_trans.full) begin 
                        error = 1;
                        `uvm_error(get_full_name(),$sformatf("COUT MIS-MATCHES"));
                    end
                end 

                else begin
                    if(act_trans.dout != exp_trans.dout || act_trans.empty != exp_trans.empty || act_trans.full != exp_trans.full) begin
                        error = 1;
                        `uvm_error(get_full_name(),$sformatf("COUT MIS-MATCHES"));
                    end
                end
            end
        end 
    endtask

    function void report_phase(input uvm_phase phase);
        if(error==0) begin
          $display("-------------------------------------------------");
          $display("------ INFO : TEST CASE PASSED ------------------");
          $display("-----------------------------------------");
        end else begin
          $display("---------------------------------------------------");
          $display("------ ERROR : TEST CASE FAILED ------------------");
          $display("---------------------------------------------------");
        end
      endfunction 
endclass

`endif
