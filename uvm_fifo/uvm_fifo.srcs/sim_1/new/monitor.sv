`ifndef MONITOR_SV
`define MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_interface fifo_if;
    uvm_analysis_port#(fifo_seqitem) mon2sb_port;
    fifo_seqitem act_trans;
    bit is_first; // Thêm biến cờ để theo dõi lần đầu

    function new(input string name = "fifo_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "fifo_interface", fifo_if))
            `uvm_fatal("MONITOR_NO_IF", {get_full_name(), "not found interface"});
        mon2sb_port = new("mon2sb_port", this);
        act_trans = new("act_trans");
        is_first = 1; // Đặt cờ là lần đầu
    endfunction

    virtual task run_phase(input uvm_phase phase);
        forever begin
            collect_trans();

            if (is_first) begin
                is_first = 0; // Sau lần đầu tiên, tắt cờ
            end else begin
                mon2sb_port.write(act_trans);
            end
        end
    endtask

    task collect_trans();
        // Chờ cho đến khi tín hiệu reset (rstn) được thả
        wait(fifo_if.rstn);
        
        // Chờ một sự kiện clocking block rc_cb
        @(fifo_if.rc_cb);
    
        // Gán giá trị từ rc_cb vào transaction act_trans
        act_trans.din = fifo_if.rc_cb.din;
        act_trans.wr_en = fifo_if.rc_cb.wr_en;
        act_trans.rd_en = fifo_if.rc_cb.rd_en;
        act_trans.dout = fifo_if.rc_cb.dout;
        act_trans.empty = fifo_if.rc_cb.empty;
        act_trans.full = fifo_if.rc_cb.full;
    endtask
endclass

`endif
