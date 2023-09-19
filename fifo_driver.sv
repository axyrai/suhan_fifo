class fifo_driver extends uvm_driver#(transaction);
  virtual fifo_interface vif;
  transaction req;
  `uvm_component_utils(fifo_driver)
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Driver: ", "No vif is found!")
  endfunction

  virtual task run_phase(uvm_phase phase);
    // reset condition
    if(vif.d_mp.rstn==0) begin
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_wren <= 'b0;
    vif.d_mp.d_cb.i_rden <= 'b0;
    vif.d_mp.d_cb.i_wrdata <= 'b0;
    end
//     else begin
    forever begin
      //write task
      seq_item_port.get_next_item(req);
      if(req.i_wren == 1) begin
        @(posedge vif.d_mp.clk)
        vif.d_mp.d_cb.i_wren <= 'b1;
        vif.d_mp.d_cb.i_wrdata <= req.i_wrdata;
        @(posedge vif.d_mp.clk)
        vif.d_mp.d_cb.i_wren <= 'b0;
      end
      //read task
      else if(req.i_rden == 1) begin
        @(posedge vif.d_mp.clk)
        vif.d_mp.d_cb.i_rden <= 'b1;
        @(posedge vif.d_mp.clk)
        vif.d_mp.d_cb.i_rden <= 'b0;
      end
      seq_item_port.item_done();
    end
//    end
  endtask
  
//   virtual task main_write(input [7:0] din);
//     @(posedge vif.d_mp.clk)
//     vif.d_mp.d_cb.wr <= 'b1;
//     vif.d_mp.d_cb.data_in <= din;
//     @(posedge vif.d_mp.clk)
//     vif.d_mp.d_cb.wr <= 'b0;
//   endtask
  
//   virtual task main_read();
//     @(posedge vif.d_mp.clk)
//     vif.d_mp.d_cb.rd <= 'b1;
//     @(posedge vif.d_mp.clk)
//     vif.d_mp.d_cb.rd <= 'b0;
//   endtask

endclass
  
   