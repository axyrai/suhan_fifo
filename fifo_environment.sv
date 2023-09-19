`include "fifo_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_subscriber.sv"

class fifo_environment extends uvm_env;
  fifo_agent f_agt;
  fifo_scoreboard f_scb;
  fifo_subscriber f_sr;
  `uvm_component_utils(fifo_environment)
  
  function new(string name = "fifo_environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    f_agt = fifo_agent::type_id::create("f_agt", this);
    f_scb = fifo_scoreboard::type_id::create("f_scb", this);
    f_sr = fifo_subscriber::type_id::create("f_sr", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    f_agt.f_mon.item_got_port.connect(f_scb.item_got_export);
    f_agt.f_mon.item_got_port.connect(f_sr.item_got_export1);
  endfunction
  
endclass