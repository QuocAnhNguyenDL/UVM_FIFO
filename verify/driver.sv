`ifndef DRIVER_SV
`define DRIVER_SV

`include "uvm_macros.svh"
`include "seqitem.sv"
`include "interface.sv"
import uvm_pkg::*;


class fifo_driver extends uvm_driver #(fifo_seqitem);
    `uvm_component_utils(fifo_driver)

    virtual fifo_interface fifo_if;
    uvm_analysis_port#(fifo_seqitem) drv2rm_port;

    function new(input string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_interface)::get(this,"","fifo_interface",fifo_if))
            `uvm_fatal("DRIVER_NO_IF", {get_full_name(), "not found the interface"});
        drv2rm_port = new("drv2rm_port", this);
    endfunction

    virtual task run_phase(input uvm_phase phase);
        reset();
        forever begin
            //`uvm_info("test_d", "DUNG1", UVM_LOW)
            seq_item_port.get_next_item(req);
            drive(req);
            $cast(rsp, req.clone());
            rsp.set_id_info(req);
            drv2rm_port.write(rsp);
            seq_item_port.item_done();
            seq_item_port.put(rsp);
        end
    endtask

    virtual task reset();
        fifo_if.dr_cb.din <= 0;
        fifo_if.dr_cb.rd_en <= 0;
        fifo_if.dr_cb.wr_en <= 0;
    endtask

    virtual task drive(input fifo_seqitem item);
        wait(fifo_if.rstn);
        @(fifo_if.dr_cb);
        fifo_if.dr_cb.din <= item.din;
        fifo_if.dr_cb.rd_en <= item.rd_en;
        fifo_if.dr_cb.wr_en <= item.wr_en;
    endtask

endclass  

`endif
