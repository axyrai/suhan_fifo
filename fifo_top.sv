import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_interface.sv"
`include "fifo_test.sv"

module tb;
  bit clk=0;
  bit rstn;
  
  always #5 clk = ~clk;
  
  initial begin
    @(posedge clk)
    rstn = 0;
    #5;
    reset = 1;
  end
  
  fifo_interface tif(clk, reset);
  
  SYN_FIFO dut(.clk(tif.clk),
               .reset(tif.rstn),
               .data_in(tif.i_wrdata),
               .wr(tif.i_wren),
               .rd(tif.i_rden),
               .full(tif.o_full),
               .empty(tif.o_empty),
               .alm_full(tif.o_alm_full),
               .alm_empty(tif.o_alm_empty),
               .data_out(tif.data_out));
  
  initial begin
    uvm_config_db#(virtual f_interface)::set(null, "", "vif", tif);
    $dumpfile("dump.vcd"); 
    $dumpvars;
    run_test("f_test");
  end
  
endmodule