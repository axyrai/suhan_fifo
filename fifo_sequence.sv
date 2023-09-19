class fifo_sequence extends uvm_sequence #(transaction); 
  `uvm_object_utils(fifo_sequence)
    
    transaction req;

  function new(string name = "fifo_sequence");
        super.new(name); 
    endfunction
    
    virtual task body();
       `uvm_info(get_type_name(), $sformatf("******** Generate 1024 Write REQs ********"), UVM_LOW)
    repeat(10) begin
      req = transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {i_wren == 1;});
      finish_item(req);
    end
     #5;
    `uvm_info(get_type_name(), $sformatf("******** Generate 1024 Read ZZZ ********"), UVM_LOW)
      repeat(10) begin
      req = transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {i_rden== 1;});
      finish_item(req);
    end
         
        `uvm_info(get_type_name(), $sformatf("******** Generate 10 alternate read write ********"), UVM_LOW)
        repeat(10) begin
           req = transaction::type_id::create("req");
           start_item(req);
           assert(req.randomize() with {i_wren == 1;i_rden==0;});
           finish_item(req);
         
          req = transaction::type_id::create("req");
          start_item(req);
          assert(req.randomize() with {i_rden == 1;i_wren==0;});
           finish_item(req);
        end

    `uvm_info(get_type_name(), $sformatf("******** Generate 50 Random REQs ********"), UVM_LOW)
    repeat(50) begin
      req = transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
 
endclass : fifo_sequence 